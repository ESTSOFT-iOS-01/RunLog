//
//  LocationManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import Foundation
import UIKit
import MapKit
import WeatherKit
import CoreLocation
import Combine

//struct DummyWeather {
//    let temperature: Int
//    let condition: WeatherCondition
//    //    let aqi: Int
//}
final class LocationManager: NSObject, CLLocationManagerDelegate {
//    // MARK: - Dummy
//    private var dummyIndex = 0
//    private var timer: Timer?
//    func startDummyLocationUpdates() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            guard dummyIndex < DummyLocation.route.count else {
//                self.timer?.invalidate()
//                return
//            }
//            let dummyLocation = DummyLocation.route[self.dummyIndex]
//            self.dummyIndex += 1
//            self.locationSubject.send(dummyLocation) // ViewModel로 위치 데이터 전송
//        }
//    }
//    func stopDummyLocationUpdates() {
//        timer?.invalidate()
//        timer = nil
//        dummyIndex = 0
//    }
    
    // MARK: - Singleton
    static let shared = LocationManager()
    // MARK: - Properties
    var isRunning: Bool = false
    private var previousLocality: String? // 지난(시군구) 위치
    private var currentLocality: String? // 현재(시군구) 위치
    private var locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    private let openWeatherService = OpenWeatherService()
    private var cancellables = Set<AnyCancellable>()
    var currentLocation: CLLocation {
        // 현재 위치를 반환, 못찾으면 서울을 기본값으로 반환
        return locationManager.location ?? CLLocation(latitude: 37.5665, longitude: 126.9780)
    }
    private var previousLocation: CLLocation?
    private var kalmanFilter = KalmanFilter()
    
    // MARK: - Combine Subjects
//    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    let locationSubject = PassthroughSubject<CLLocation, Never>() // testcode
    private let distanceSubject = PassthroughSubject<Double, Never>()
    private let locationNameSubject = PassthroughSubject<CLPlacemark, Never>()
    private let weatherUpdateSubject = PassthroughSubject<(String, Double), Never>()
    private let aqiUpdateSubject = PassthroughSubject<Int, Never>()
    // MARK: - Publisher
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    var distancePublisher: AnyPublisher<Double, Never> {
        distanceSubject.eraseToAnyPublisher()
    }
    var locationNamePublisher: AnyPublisher<CLPlacemark, Never> {
        locationNameSubject.eraseToAnyPublisher()
    }
    var weatherUpdatePublisher: AnyPublisher<(String, Double), Never> {
        weatherUpdateSubject.eraseToAnyPublisher()
    }
    var aqiUpdatePublisher: AnyPublisher<Int, Never> {
        aqiUpdateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    private override init() {
        super.init()
        setupLocationManager()
        previousLocation = nil
    }
    deinit {
        locationManager.stopUpdatingLocation()
    }
    // MARK: - CLLocationManager 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 배터리를 아낄려면 kCLLocationAccuracyHundredMeters를 이용 - 정확도를 조절
        locationManager.distanceFilter = 50  //100미터를 이동하면 다시 업데이트
        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = false // 이동이 없으면 업데이트를 멈출지
        getLocationUsagePermission()
    }
    // MARK: - 이동하면 위치를 받아 ViewModel에 input넣음
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // GPS오차가 큰 경우 무시 - 거리가 10m이상 벌어지면? 인듯
        
        if previousLocation != nil && (location.horizontalAccuracy < 0 || location.horizontalAccuracy > 10) {
            print("GPS 신호 불안정 - 위치 무시")
            return
        }
        // Kalman Filter 적용(좌표 보정)
        let filteredLat = kalmanFilter.update(measurement: location.coordinate.latitude)
        let filteredLog = kalmanFilter.update(measurement: location.coordinate.longitude)
        let filteredLocation = CLLocation(
            latitude: filteredLat,
            longitude: filteredLog
        )
        
        if let previous = previousLocation {
            let distance = filteredLocation.distance(from: previous)
            if distance >= 1 {
                distanceSubject.send(distance)
            }
        }
        previousLocation = filteredLocation
        
        self.locationSubject.send(location)
        // 도시명 패치
        fetchCityName(location: location)
        // 날씨를 받아올지 판단해서 업데이트
        if  weatherUpdateCheck() {
            fetchWeatherData(location: location) // 날씨 정보 패치
            fetchAqiData(location: location) // 대기질 정보 패치
        }
    }
    // MARK: - 날씨랑 대기질 정보를 받아오는 기준점
    private func weatherUpdateCheck() -> Bool {
        if previousLocality == nil { return true }
        if !isRunning && (previousLocality != currentLocality) { return true }
        return false
    }
    // MARK: - 도시명 가져오기
    private func fetchCityName(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {
            [weak self] placemarks, error in
            guard let self = self else { return }
            guard let placemark = placemarks?.first else {
                print("Geocoding 실패: \(error!.localizedDescription)")
                return
            }
            self.previousLocality = self.currentLocality
            self.currentLocality = placemark.locality
            self.locationNameSubject.send(placemark)
        }
    }
}
// MARK: - 날씨 정보
extension LocationManager {
    // MARK: - openWeather로 날씨를 받아옴
    private func fetchWeatherData(location: CLLocation) {
        openWeatherService.fetchWeather(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                print("데이터 요청 실패: \(error.errorMessage)")
            }
        } receiveValue: { response in
            let temperature: Double = response.main.temp
            let condition: String = response.weather.first?.description ?? "알 수 없음"
            self.weatherUpdateSubject.send((condition, temperature))
        }
        .store(in: &cancellables)
    }
}
// MARK: - 대기질 정보
extension LocationManager {
    // MARK: - openWeather로 대기질을 받아옴
    private func fetchAqiData(location: CLLocation) {
        openWeatherService.fetchAirQuality(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            if case let .failure(error) = completion {
                print("데이터 요청 실패: \(error.errorMessage)")
                self.aqiUpdateSubject.send(-1)
            }
        } receiveValue: { response in
            let aqi = response.list.first?.main.aqi ?? 3 // 기본값 '나쁨(3)' 설정
            print("현재 Aqi 값: \(aqi)")
            self.aqiUpdateSubject.send(aqi)
        }
        .store(in: &cancellables)
    }
}
// MARK: - 위치 정보 권한 요청
extension LocationManager {
    // MARK: - 권한 정보가 바뀌면 실행
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocationUsagePermission()
    }
    // MARK: - 권한 정보에 따른 분기 처리
    private func getLocationUsagePermission() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined: // 허용 안한 상태
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse: // 앱을 사용동안 허용
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied: // 거부 상태
            print("위치 권한이 거부됨 - 설정에서 변경 필요")
            openAppSettings()
        case .authorizedAlways: // 항상 허용
            locationManager.startUpdatingLocation()
        @unknown default:
            return
        }
    }
    // MARK: - 앱 설정 열기
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - KalmanFilter
final class KalmanFilter {
    private var x: Double = 0  // 위치 추정값
    private var p: Double = 1  // 오차 공분산
    private let q: Double = 0.0001 // 프로세스 노이즈
    private let r: Double = 0.01 // 측정 노이즈
    
    func update(measurement: Double) -> Double {
        // 1. 예측 단계
        let xPred = x
        let pPred = p + q
        
        // 2. 업데이트 단계
        let k = pPred / (pPred + r)
        x = xPred + k * (measurement - xPred)
        p = (1 - k) * pPred
        
        return x
    }
}
