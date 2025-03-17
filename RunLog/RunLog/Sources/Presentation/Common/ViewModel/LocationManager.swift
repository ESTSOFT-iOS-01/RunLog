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

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    let weatherService = WeatherService()
    
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
    // MARK: - 이동하면 현재 위치를 받아오는 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print(location) // 마지막 위치 출력
        fetchData(location: location)
    }
    // MARK: - 정보 업데이트
    private func fetchData(location: CLLocation) {
        fetchCityName(location: location)
        fetchWeather(location: location)
    }
    // MARK: - 위치를 주면 도시명을 받아옴
    private func fetchCityName(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { fullName, _ in
            print("전체 이름: \(fullName)")
//            let city = placemarks?.first?.locality ?? "알 수 없음"
        }
    }
    // MARK: - 위치를 주면 날씨를 받아옴
    func fetchWeather(location: CLLocation) {
        Task {
            do {
//                let weather = try await weatherService.weather(for: location)
//                print(weather.currentWeather.temperature)
//                print(weather.currentWeather.condition)
                let weather = dummyWeatherSet()
            }catch {
                print("WeatherKit 날씨 데이터 가져오기 실패: \(error.localizedDescription)")
            }
        }
    }
    // MARK: - dummyWeather
    // 날씨 정보 - 온도, 상태, 대기질
    struct dummyWeather {
        let temperature: Int
        let condition: WeatherCondition
        let aqi: Int
    }
    private func dummyWeatherSet() -> dummyWeather {
        let temperature: Int = Int.random(in: -20...40)
        let condition: WeatherCondition = .clear
        let aqi: Int = Int.random(in: 1...5)
        return dummyWeather(temperature: temperature, condition: condition, aqi: aqi)
    }
}



//
//// MARK: - 대기질 관련 - 아직 사용X
//extension LocationManager {
//    // 대기질 상태 - 한글
//    private func aqiDescription(_ aqi: Int) -> String {
//        switch aqi {
//        case 1: return "좋음"
//        case 2: return "보통"
//        case 3: return "나쁨"
//        case 4: return "매우 나쁨"
//        case 5: return "위험"
//        default: return "정보 없음"
//        }
//    }
//    // 날씨 상태 - 한글
//    enum WeatherCondition: String {
//        case clear = "맑음"
//        case cloudy = "흐림"
//        case rainy = "비"
//        case snowy = "눈"
//        case stormy = "폭풍"
//    }
//    
//}





//
//// MARK: - private Functions
//extension LocationManager {
//    // 위치의 attributedString 반환
//    var curLocationStr: NSAttributedString {
//        let str = currentLocation()
//        return .RLAttributedString(text: str, font: .Label2, align: .center)
//    }
//    // 날씨의 attributedString 반환
//    var curWeatherStr: NSAttributedString {
//        let str = currentWeather()
//        return .RLAttributedString(text: str, font: .Label2, align: .center)
//    }
//    
//    
//    /// 현재 위치의 도시명을 받아와서 String으로 반환
//    private func currentLocation() -> String {
//        return currentCity
//    }
//    /// 현재 위치(currentLocation의 위치)의 날씨, 온도, 미세먼지 농도를 받아와서 String으로 반환
//    private func currentWeather() -> String {
//        let weather = dummyWeatherSet()
//        return "\(weather.condition.rawValue) | \(weather.temperature)°C, 미세먼지 \(aqiDescription(weather.aqi))"
//    }
//    
//}
