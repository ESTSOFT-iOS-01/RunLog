//
//  Running.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//

import UIKit
import Combine
import MapKit

final class RunningViewModel {
    
    // MARK: - Init
    init() { }
    
    
    // MARK: - Input
    enum Input {
        case requestRunningStop // 운동종료 요청
        case requestCurrentLocation
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responseRunningStop // 운동종료
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case responseCurrentTimes(String) // 운동 시간 데이터
        case responseCurrentDistances(String) // 운동 거리 데이터
        case responseCurrentSteps(String) // 운동 걸음 수 데이터
        case lineDraw(MKPolyline) // 지도에 라인을 그림
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var provider = RunningDataProvider.shared
    
    
    // MARK: - Binding
    func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestRunningStop:
                    self.provider.input.send(.requestRunningStop)
                case .requestCurrentLocation:
                    self.provider.input.send(.requestCurrentLocation)
                }
            }
            .store(in: &cancellables)
        
        // ViewModel에서 필요한 정보는 provider로 부터 주입
        provider.runningOutput
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseRunningStop:
                    self.output.send(.responseRunningStop)
                case .responseCurrentLocation(let location):
                    self.output.send(.locationUpdate(location))
                case .responseCurrentTimes(let times):
                    let timeString = times.asTimeString
                    self.output.send(.responseCurrentTimes(timeString))
                case .responseCurrentDistances(let distances):
                    let distanceString = "\((distances / 1000).toString(withDecimal: 2))km"
                    self.output.send(.responseCurrentDistances(distanceString))
                case .responseCurrentSteps(let steps):
                    let stepString = "\(steps)"
                    self.output.send(.responseCurrentSteps(stepString))
                case .responseLineDraw(let polyline):
                    self.output.send(.lineDraw(polyline))
                }
            }
            .store(in: &cancellables)
    }
}
