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
    // MARK: - Propertise
    private let pedometer = CMPedometer()
    private let pedometerSubject = PassthroughSubject<Int, Never>()
    var pedometerPublisher: AnyPublisher<Int, Never> {
        pedometerSubject.eraseToAnyPublisher()
    }
    // MARK: - Init
    private init() { }
    // MARK: - 걸음 수 측정 시작
    func startPedometerUpdate() {
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
            self.pedometerSubject.send(stepCount)
        }
    }
    // MARK: - 걸음 수 측정 종료
    func stopPedometerUpdate() {
        pedometer.stopUpdates()
        print("걸음 수 측정 중지")
    }
}
