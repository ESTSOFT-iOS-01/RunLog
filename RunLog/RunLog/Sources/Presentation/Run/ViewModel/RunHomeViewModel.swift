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
    enum Input {
        case locationUpdate(CLLocation) // 사용자의 위치가 바뀜
    }
    
    enum Output {
        case locationUpdate(String) // 사용자의 위치
        case weatherUpdate(DummyWeather) // 현재 날씨
    }
    let locationManager = LocationManager.shared
    
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .locationUpdate(let location):
                    self?.fetchLocationData(for: location)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 위치 & 날씨 데이터 가져오기
    private func fetchLocationData(for location: CLLocation) {
        locationManager.fetchCityName(location: location) { [weak self] city in
            print("📍 도시명 업데이트: \(city)")
            self?.output.send(.locationUpdate(city))
        }
        
        locationManager.fetchWeather(location: location) { [weak self] weather in
            print("🌤 날씨 업데이트: \(weather.temperature)°C, \(weather.condition)")
            self?.output.send(.weatherUpdate(weather))
        }
    }
}
