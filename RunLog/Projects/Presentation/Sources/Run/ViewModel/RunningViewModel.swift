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
    
    // MARK: - Input
    enum Input {
        case requestRunningStop // 운동종료 요청
        case requestCurrentLocation
    }
    
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case currentTime(String)
        case locationUpdate(CLLocation) // 사용자 위치 데이터
        case responseCurrentDistances(String) // 운동 거리 데이터
        case responseCurrentSteps(String) // 운동 걸음 수 데이터
        case lineDraw(MKPolyline) // 지도에 라인을 그림
    }
    
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var provider = RunningDataProvider.shared
    private var startTime: Date = .now
    
    // MARK: - Init
    init() {
        startTimer()
    }
    
    // MARK: - Binding
    func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                // 운동 종료
                case .requestRunningStop:
                    self.provider.input.send(.requestRunningStop)
                // 사용자의 위치를 받아서 업데이트
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
                    // 제거 필요
                    return
                    
                case .responseCurrentLocation(let location):
                    self.output.send(.locationUpdate(location))
                    
                case .responseCurrentTimes(let times):
                    // 제거 필요
                    return
                    
                case .responseCurrentDistances(let distances):
                    let distanceString = "\(distances.toString(withDecimal: 2))km"
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


private extension RunningViewModel {
    func startTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { [weak self] now in
                guard let self = self else { return }
                let time = now.timeIntervalSince(self.startTime)
                self.output.send(.currentTime(time.asTimeString))
            })
            .store(in: &cancellables)
    }
}
