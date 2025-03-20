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
    private var previousLocality: String? // 지난 위치
    private var currentLocality: String? // 현재 위치
    private var locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    private let openWeatherService = OpenWeatherService()
    private var cancellables = Set<AnyCancellable>()
    var currentLocation: CLLocation {
        // 현재 위치를 반환, 못찾으면 서울을 기본값으로 반환
        return locationManager.location ?? CLLocation(latitude: 37.5665, longitude: 126.9780)
    }
    // MARK: - Combine Subjects
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private let locationNameSubject = PassthroughSubject<CLPlacemark, Never>()
    private let weatherUpdateSubject = PassthroughSubject<(String, Double), Never>()
    private let aqiUpdateSubject = PassthroughSubject<Int, Never>()
    // MARK: - Publisher
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
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
    }
    deinit {
//        timer?.invalidate()
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
//        let location = CLLocation(latitude: 37.5665, longitude: 126.9780)
        self.locationSubject.send(location) // 더미 지우고 여기 풀면 현재 위치 기준으로 작성
        // 도시명 패치 - 이걸 위치 따라 지정
        fetchCityName(location: location)
        
        // 운동 중이 아니면서 시,군,구 가 바뀌면 날씨를 새로 받아옴
        if !isRunning && (previousLocality != currentLocality) {
            fetchWeatherData(location: location) // 날씨 정보 패치
            fetchAqiData(location: location) // 대기질 정보 패치
        }
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
