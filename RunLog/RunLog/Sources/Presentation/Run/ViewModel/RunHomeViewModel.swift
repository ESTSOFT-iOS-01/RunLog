//
//  Run.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//

import UIKit
import Combine
import MapKit

final class RunHomeViewModel {
    // MARK: - Input & Output
    enum Output {
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case locationNameUpdate(String) // 가공된 위치 데이터
        case weatherUpdate(String)  // 가공된 날씨 데이터
    }
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Properties
    private let locationManager = LocationManager.shared
    private let openWeatherService = OpenWeatherService.shared
    private var previousLocation: CLLocation?
    // MARK: - Init
    init() {
        bind()
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        // 사용자 위치 변경 구독 -> location에 맞는 지도 이동
        locationManager.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.output.send(.locationUpdate(location))
            }
            .store(in: &cancellables)
        // 도시명 변경 구독
        locationManager.locationNamePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                let location = value.0
                let placemark = value.1
                let city = self.placemarksToString(placemark)
                print(city)
                
                // +) 여기서 기존의 지역과 다르면 locationNameUpdate를 부르고 날씨 변경도 부름
                if previousLocation != location {
                    print("날씨정보 업데이트")
                    self.openWeatherService.input.send(.requestUpdate(location))
                    self.output.send(.locationNameUpdate(city))
                }
                previousLocation = location
            }
            .store(in: &cancellables)
        // 날씨 및 대기질 변경 구독
        Publishers.Zip(
            openWeatherService.weatherUpdatePublisher,
            openWeatherService.aqiUpdatePublisher
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            print(completion)
        } receiveValue: { [weak self] weather, aqi in
            let formattedString = "\(weather.0) | \(weather.1.toString(withDecimal: 1))°C 대기질 \(self?.aqiToString(aqi) ?? "알 수 없음")"
            self?.output.send(.weatherUpdate(formattedString))
        }
        .store(in: &cancellables)
    }
}
// MARK: - 정보 한글화
extension RunHomeViewModel {
    // MARK: - 대기질 정보 -> 한글
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
    // MARK: - 위치 정보 -> 한글
    private func placemarksToString(_ placemark: CLPlacemark) -> String {
        var state: String = "" // 도, 광역시
        var city: String = "" // 시, 군, 구
        var district: String = "" // 동, 읍, 면
        if let subLocal = placemark.subLocality, subLocal.hasSuffix("동") {
            district = subLocal
        }
        let description: String = String(
            placemark
                .description
                .split(separator: ",")
                .filter{ $0.contains("대한민국") }
                .first
            ?? "")
        let components = description.split(separator: " ").map { String($0) }
        for component in components {
            if state == "" && (component.hasSuffix("특별시") || component.hasSuffix("광역시") || component.hasSuffix("도")) {
                state = component
            }else if city == "" && (component.hasSuffix("시") || component.hasSuffix("군") || component.hasSuffix("구")) {
                city = component
            }else if district == "" && (component.hasSuffix("동") || component.hasSuffix("읍") || component.hasSuffix("면") || component.hasSuffix("로")) {
                district = component
            }
        }
        return district.isEmpty ? "\(state) \(city)에서" : "\(state) \(city) \(district)에서"
    }
}
