//
//  PedometerManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
import Combine
import CoreMotion

/// 사용자가 걸은 걸음수를 받아오는 매니저
public final class PedometerManager {
    
    // MARK: - Singleton
    public static let shared = PedometerManager()
    private init() {
        bind()
    }
    
    
    // MARK: - Input
    public enum Input {
        case requestPedometerStart
        case requestPedometerStop
    }
    public let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    public enum Output {
        case responseSteps(Int)
    }
    public let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let pedometer = CMPedometer()
    
    
    // MARK: - Binding
    private func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestPedometerStart:
                    self.pedometerUpdateStart()
                    
                case .requestPedometerStop:
                    self.pedometerUpdateStop()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 걸음 수 측정 시작
    private func pedometerUpdateStart() {
        
        /// 걸음수를 측정 가능한 기기 확인
        guard CMPedometer.isStepCountingAvailable() else {
            print("측정 불가 기기")
            return
        }
        
        /// 측정가능한 기기의 경우 측정 시작
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self,
                  let data = data,
                  error == nil
            else { return }
            
            // 걸음수를 Int로 변경
            let stepCount = data.numberOfSteps.intValue
            self.output.send(.responseSteps(stepCount))
        }
    }
    
    // MARK: - 걸음 수 측정 종료
    private func pedometerUpdateStop() {
        pedometer.stopUpdates()
    }
}
