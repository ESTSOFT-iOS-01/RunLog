//
//  Run.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//

import UIKit
import Combine
import MapKit
import WeatherKit

final class RunHomeViewModel {
    // MARK: - Input & Output
    enum Input {
        case locationUpdate(CLPlacemark)
        case weatherUpdate(WeatherData)
    }
    let input = PassthroughSubject<Input, Never>()
    enum Output {
        case locationUpdate(String) // 가공된 위치 데이터
        case weatherUpdate(String)  // 가공된 날씨 데이터
    }
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    
    // MARK: - Init
    init() {
        bind()
        locationManager.runHomeViewModel = self
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                switch input {
                case .locationUpdate(let placemark): // 도시명 변경
                    let city = self?.placemarksToString(placemark) ?? "알 수 없음"
                    self?.output.send(.locationUpdate(city))
                case .weatherUpdate(let weather): // 날씨 변경
                    let condition = self?.conditionToString(weather.condition) ?? weather.condition.rawValue
                    let temperature = "\(weather.temperature)°C"
                    let aqi = self?.aqiToString(weather.airQuality) ?? "정보 없음"
                    
                    let formattedString = "\(condition) | \(temperature), 미세먼지 \(aqi)"
                    self?.output.send(.weatherUpdate(formattedString))
                }
            }
            .store(in: &cancellables)
//        // 도시명 변경 구독
//        locationManager.locationPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] placemark in
//                let city = self?.placemarksToString(placemark) ?? "알 수 없음"
//                self?.output.send(.locationUpdate(city))
//            }
//            .store(in: &cancellables)
//        // 날씨 변경 구독
//        locationManager.weatherPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] weather in
//                print("날씨: \(weather)")
//                let condition = self?.conditionToString(weather.condition) ?? weather.condition.rawValue
//                let temperature = "\(weather.temperature)°C"
//                let aqi = self?.aqiToString(weather.airQuality) ?? "정보 없음"
//                
//                let formattedString = "\(condition) | \(temperature), 미세먼지 \(aqi)"
//                self?.output.send(.weatherUpdate(formattedString))
//            }
//            .store(in: &cancellables)
    }
    // MARK: - 위치 정보 데이터 -> 한글
    private func placemarksToString(_ placemark: CLPlacemark) -> String {
        let state = placemark.administrativeArea ?? ""  // 도, 광역시
        let city = placemark.locality ?? ""             // 시, 군, 구
        let district = placemark.subLocality ?? ""      // 동, 읍, 면
        
        if district.isEmpty {
            return "\(state) \(city)에서"
        } else {
            return "\(state) \(city) \(district)에서"
        }
    }
    // MARK: - 날씨 정보 데이터 -> 한글
    private func conditionToString(_ condition: WeatherCondition) -> String {
        switch condition {
        case .clear: return "맑음"
        case .cloudy: return "흐림"
        case .rain: return "비"
        case .snow: return "눈"
        case .strongStorms: return "폭풍"
        default: return condition.rawValue
        }
    }
    private func aqiToString(_ aqi: Int) -> String {
        switch aqi {
        case 1: return "좋음"
        case 2: return "보통"
        case 3: return "나쁨"
        case 4: return "매우 나쁨"
        case 5: return "위험"
        default: return "정보 없음"
        }
    }
}
