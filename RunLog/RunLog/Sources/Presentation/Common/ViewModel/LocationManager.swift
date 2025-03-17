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
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    
    // MARK: - Combine
    private let locationSubject = PassthroughSubject<CLPlacemark, Never>()
    private let weatherSubject = PassthroughSubject<WeatherData, Never>()
    var locationPublisher: AnyPublisher<CLPlacemark, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    var weatherPublisher: AnyPublisher<WeatherData, Never> {
        weatherSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    private override init() {
        super.init()
        setupLocationManager()
    }
    // MARK: - CLLocationManager 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 배터리를 아낄려면 kCLLocationAccuracyHundredMeters를 이용 - 정확도를 조절
        locationManager.distanceFilter = 100 // 100미터를 이동하면 다시 업데이트
        locationManager.requestWhenInUseAuthorization() // 위치 권한 요청
        locationManager.startUpdatingLocation() //위치를 받아오기 시작
    }
    // MARK: - 이동하면 위치를 받아 ViewModel에 input넣음
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("현재 위치: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
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
            self.locationSubject.send(placemark)
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
            weatherSubject.send(weatherData)
        }
    }
    
    // MARK: - weatherKit으로 날씨를 받아옴
    private func fetchWeatherKitData(location: CLLocation) async -> DummyWeather {
        return DummyWeather(temperature: Int.random(in: -10...35), condition: .clear)
    }
    // MARK: - openWeatherMap으로 대기질을 받아옴
    private func fetchOpenWeatherData(location: CLLocation) async -> DummyAirQuality {
        return DummyAirQuality(aqi: Int.random(in: 1...5))
    }
}
