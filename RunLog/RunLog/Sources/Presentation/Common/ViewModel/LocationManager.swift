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

// MARK: - WeatherData (날씨 + 대기질 정보)
struct WeatherData {
    let temperature: Int
    let condition: WeatherCondition
    let airQuality: Int
}
struct DummyWeather {
    let temperature: Int
    let condition: WeatherCondition
    //    let aqi: Int
}
// MARK: - 더미 데이터 (Air Quality)
struct DummyAirQuality {
    let aqi: Int
}
final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Dummy
    private var dummyIndex = 0
    private var timer: Timer?
    func startDummyLocationUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard dummyIndex < DummyLocation.route.count else {
                self.timer?.invalidate()
                return
            }
            let dummyLocation = DummyLocation.route[self.dummyIndex]
            self.dummyIndex += 1
            self.locationSubject.send(dummyLocation) // ViewModel로 위치 데이터 전송
        }
    }
    
    // MARK: - Singleton
    static let shared = LocationManager()
    // MARK: - Property
    private var locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    var currentLocation: CLLocation {
        // 현재 위치를 반환, 못찾으면 서울을 기본값으로 반환
//        return dummyLocation
        return locationManager.location ?? CLLocation(latitude: 37.5665, longitude: 126.9780)
    }
    
    // MARK: - Combine
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private let locationNameSubject = PassthroughSubject<CLPlacemark, Never>()
    private let weatherSubject = PassthroughSubject<WeatherData, Never>()
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    var locationNamePublisher: AnyPublisher<CLPlacemark, Never> {
        locationNameSubject.eraseToAnyPublisher()
    }
    var weatherPublisher: AnyPublisher<WeatherData, Never> {
        weatherSubject.eraseToAnyPublisher()
    }
    // MARK: - Init
    private override init() {
        super.init()
        setupLocationManager()
    }
    deinit {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    // MARK: - CLLocationManager 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 배터리를 아낄려면 kCLLocationAccuracyHundredMeters를 이용 - 정확도를 조절
        locationManager.distanceFilter = 100  //100미터를 이동하면 다시 업데이트
        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = false // 이동이 없으면 업데이트를 멈출지
        getLocationUsagePermission()
    }
    // MARK: - 이동하면 위치를 받아 ViewModel에 input넣음
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
//        self.locationSubject.send(location) // 더미 지우고 여기 풀면 현재 위치 기준으로 작성
        fetchCityName(location: location)
        fetchWeatherData(location: location)
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
            self.locationNameSubject.send(placemark)
        }
    }
    // MARK: - 날씨 데이터 가져오기
    private func fetchWeatherData(location: CLLocation) {
        Task {
            async let weather = fetchWeatherKitData(location: location)
            async let aqi = fetchOpenWeatherData(location: location)
            
            let weatherData = await WeatherData(
                temperature: weather.temperature,
                condition: weather.condition,
                airQuality: aqi.aqi
            )
            self.weatherSubject.send(weatherData)
        }
    }
    // MARK: - weatherKit으로 날씨를 받아옴
    private func fetchWeatherKitData(location: CLLocation) async -> DummyWeather {
        return DummyWeather(temperature: Int.random(in: -10...35), condition: .clear)
    }
    // MARK: - openWeatherMap으로 대기질을 받아옴
    private func fetchOpenWeatherData(location: CLLocation) async -> DummyAirQuality {
        guard let apiKey = Bundle.main.weatherKey else {
            print("API 키를 로드하지 못했습니다.")
            return DummyAirQuality(aqi: Int.random(in: 1...5))
        }
        
        
        
        return DummyAirQuality(aqi: Int.random(in: 1...5))
    }
}

// MARK: - 위치 정보 권한 요청
extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocationUsagePermission()
    }
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
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}






struct DummyLocation {
    static let route: [CLLocation] = {
        let center = CLLocationCoordinate2D(latitude: 37.554722, longitude: 126.970833) // 원의 중심 (서울역 근처)
        let radius: Double = 0.00135 // 150m (위도/경도 변환값)
        let totalPoints = 20 // 100개 좌표
        
        var locations: [CLLocation] = []
        
        for i in 0..<totalPoints {
            let angle = Double(i) / Double(totalPoints) * 2 * .pi // 0 ~ 2π (360도)
            let latOffset = radius * cos(angle) // 원 형태의 위도 변동
            let lonOffset = radius * sin(angle) // 원 형태의 경도 변동
            
            let newLat = center.latitude + latOffset
            let newLon = center.longitude + lonOffset
            
            locations.append(CLLocation(latitude: newLat, longitude: newLon))
        }
        
        return locations
    }()
}
