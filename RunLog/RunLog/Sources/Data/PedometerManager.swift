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
    // MARK: - Input & Output
    enum Input {
        case startPedometer
        case stopPedometer
    }
    let input = PassthroughSubject<Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    private let pedometerSubject = PassthroughSubject<Int, Never>()
    var pedometerPublisher: AnyPublisher<Int, Never> {
        pedometerSubject.eraseToAnyPublisher()
    }
    // MARK: - Singleton
    static let shared = PedometerManager()
    // MARK: - Propertise
    private let pedometer = CMPedometer()
    // MARK: - Init
    private init() {
        bind()
    }
    // MARK: - Bind
    private func bind() {
        self.input
            .sink { [weak self] input in
                switch input {
                case .startPedometer:
                    self?.startPedometerUpdate()
                case .stopPedometer:
                    self?.stopPedometerUpdate()
                }
            }
            .store(in: &cancellables)
    }
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
    }
}
