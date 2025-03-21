//
//  PedometerManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
import Combine
import CoreMotion

final class PedometerManager {
    
    // MARK: - Singleton
    static let shared = PedometerManager()
    private init() {
        bind()
    }
    
    
    // MARK: - Input
    enum Input {
        case requestPedometerStart
        case requestPedometerStop
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responseSteps(Int)
    }
    let output = PassthroughSubject<Output, Never>()
    
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
//        // Syr) 테스트용 Start
//        for i in 0...200 {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
//                let num = Int.random(in: 1...5)
//                self.output.send(.responseSteps(num))
//            }
//        }
//        // Syr) 테스트용 End
        // Syr) 실측정용 Start
        guard CMPedometer.isStepCountingAvailable() else {
            print("측정 불가 기기")
            return
        }
        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self,
                  let data = data,
                  error == nil
            else { return }
            let stepCount = data.numberOfSteps.intValue
            self.output.send(.responseSteps(stepCount))
        }
        // Syr) 실측정용 Start
    }
    
    // MARK: - 걸음 수 측정 종료
    private func pedometerUpdateStop() {
        pedometer.stopUpdates()
    }
}
