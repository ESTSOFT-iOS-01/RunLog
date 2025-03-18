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
    enum Output {
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case locationNameUpdate(String) // 가공된 위치 데이터
        case weatherUpdate(String)  // 가공된 날씨 데이터
    }
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    
    // MARK: - Init
    init() {
        bind()
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        // 사용자 위치 변경 구독
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locaiton in
                self?.output.send(.locationUpdate(locaiton))
            }
            .store(in: &cancellables)
        // 도시명 변경 구독
        locationManager.locationNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] placemark in
                let city = self?.placemarksToString(placemark) ?? "알 수 없음"
                self?.output.send(.locationNameUpdate(city))
            }
            .store(in: &cancellables)
        // 날씨 변경 구독
        locationManager.weatherPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                print("날씨: \(weather)")
                let condition = self?.conditionToString(weather.condition) ?? weather.condition.rawValue
                let temperature = "\(weather.temperature)°C"
                let aqi = self?.aqiToString(weather.airQuality) ?? "정보 없음"
                
                let formattedString = "\(condition) | \(temperature), 미세먼지 \(aqi)"
                self?.output.send(.weatherUpdate(formattedString))
            }
            .store(in: &cancellables)
    }
    // MARK: - 위치 정보 데이터 -> 한글
    private func placemarksToString(_ placemark: CLPlacemark) -> String {
        var state: String = "" // 도, 광역시
        var city: String = "" // 시, 군, 구
        var district: String = "" // 동, 읍, 면
        
        let description: String = String(
            placemark
                .description
                .split(separator: ",")
                .filter{ $0.contains("대한민국") }
                .first
            ?? "")
        let components = description.split(separator: " ").map { String($0) }
        for component in components {
            if component.hasSuffix("특별시") || component.hasSuffix("광역시") || component.hasSuffix("도") {
                state = component
            }else if component.hasSuffix("시") || component.hasSuffix("군") || component.hasSuffix("구") {
                city = component
            }else if component.hasSuffix("동") || component.hasSuffix("읍") || component.hasSuffix("면") {
                district = component
            }
        }
        return district.isEmpty ? "\(state) \(city)에서" : "\(state) \(city) \(district)에서"
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
