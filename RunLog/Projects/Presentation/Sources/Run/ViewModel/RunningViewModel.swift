//
//  Running.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//
import RLInject
import RLDomain

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
        case currentSteps(String) // 운동 걸음 수 데이터
        case lineDraw(MKPolyline) // 지도에 라인을 그림
    }
    
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    @Dependency private var pedometerProvider: PedometerProvider
    private var cancellables = Set<AnyCancellable>()
    private var provider = RunningDataProvider.shared
    private var startTime: Date = .now
    
    // MARK: - Init
    init() {
        startTimer()
        pedometerProvider.startPedometer()
        bind()
    }
    
    // MARK: - Binding
    private func bind() {
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
        
        self.pedometerProvider.steps
            .map { String($0) }
            .sink { [weak self] steps in
                self?.output.send(.currentSteps(steps))
            }
            .store(in: &cancellables)
    }
}


private extension RunningViewModel {
    func startTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] now in
                guard let self = self else { return }
                let time = now.timeIntervalSince(self.startTime)
                self.output.send(.currentTime(time.asTimeString))
            }
            .store(in: &cancellables)
    }
}
