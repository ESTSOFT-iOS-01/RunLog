//
//  Run.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//
import RLDomain
import RLUtil

import UIKit
import Combine
import MapKit

final class RunHomeViewModel {
    
    // MARK: - Init
    init() { }
    
    
    // MARK: - Input & Output
    enum Input {
        case requestRunningStart // 운동시작 요청
        case requestCurrentLocation
        case requestCurrentWeahter
        case requestRoadRecord
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responseRunningStart // 운동시작
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case locationNameUpdate(String) // 가공된 위치 데이터
        case weatherUpdate(String)  // 가공된 날씨 데이터
        case responseRoadRecord(NSMutableAttributedString) // 기록 데이터
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var provider = RunningDataProvider.shared
    
    // MARK: - Usecase
    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    // MARK: - Binding
    func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                
                switch input {
                // 운동시작
                case .requestRunningStart:
                    self.provider.input.send(.requestRunningStart)
                    
                // 사용자의 위치 요청
                case .requestCurrentLocation:
                    self.provider.input.send(.requestCurrentLocation)
                    
                // 사용자의 위치에 대한 날씨 요청
                case .requestCurrentWeahter:
                    self.provider.input.send(.requestCurrentWeather)
                    
                // RoadRecord 정보 요청
                case .requestRoadRecord:
                    self.getDistanceIndicator()
                }
            }
            .store(in: &cancellables)
        
        // ViewModel에서 필요한 정보는 provider에서 주입
        provider.runHomeOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                // 운동시작
                case .responseRunningStart:
                    self.output.send(.responseRunningStart)
                    
                // 사용자의 위치 요청
                case .responseCurrentLocation(let location):
                    self.output.send(.locationUpdate(location))
                    
                // 사용자의 위치에 대한 도시명 요청
                case .responseCurrentCityName(let name):
                    let updateName = name.hasSuffix("...") ? name : "\(name)에서"
                    self.output.send(.locationNameUpdate(updateName))
                    
                // 사용자의 위치에 대한 날씨 요청
                case .responseCurrentWeather(let weahter, let aqi):
                    let weatherString = self.toWeatherString(weahter, aqi)
                    self.output.send(.weatherUpdate(weatherString))
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 날씨 레이블 형태로 변경
extension RunHomeViewModel {
    private func toWeatherString(_ weather: (Int, Double), _ aqi: Int) -> String {
        
        var formattedString = ""
        
        if weather.0 == -1 { formattedString = "알 수 없음" }
        else {
            let condition = Constants.WeatherCondition.from(weather.0).description
            let temperature = weather.1.toString(withDecimal: 1)
            let aqiLevel = Constants.AqiLevel.from(aqi).description
            formattedString = "\(condition) | \(temperature)°C 대기질 \(aqiLevel)"
        }
        return formattedString
    }
}

// MARK: - Road Data 받아옴
extension RunHomeViewModel {
    private func getDistanceIndicator() {
        Task {
            let nickname = try await appConfigUseCase.getNickname()
            let (roadName, countData) = try await appConfigUseCase.getDistanceIndicators()
            let count = countData.toString(withDecimal: 2)
            
            let string = """
                         \(nickname) 님은
                         지금까지 \(roadName) \(count)회
                         거리만큼 걸었습니다!
                         """
            
            let attributedString = string.styledText(
                highlightText: "\(roadName) \(count)회",
                baseFont: .RLMainTitle,
                baseColor: .Gray000,
                highlightFont: .RLMainTitle,
                highlightColor: .LightGreen
            )
            
            self.output.send(.responseRoadRecord(attributedString))
        }
    }
}
