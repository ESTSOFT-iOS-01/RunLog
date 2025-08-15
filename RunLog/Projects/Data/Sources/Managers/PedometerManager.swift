//
//  PedometerManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//
import RLDomain

import Foundation
import Combine
import CoreMotion

/// 사용자가 걸은 걸음수를 받아오는 매니저
public final class PedometerManager: PedometerProvider {
    
    // MARK: - Private
    private let pedometer = CMPedometer()
    private let stepsSubject = PassthroughSubject<Int, Never>()
    
    public init() { }
    
    // MARK: - PedometerProvider
    public func startPedometer() {
        guard CMPedometer.isStepCountingAvailable() else {
            return
        }

        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            guard let self = self, error == nil, let data = data else { return }
            self.stepsSubject.send(data.numberOfSteps.intValue)
        }
    }

    public func stopPedometer() {
        pedometer.stopUpdates()
    }
    
    public var steps: AnyPublisher<Int, Never> {
        stepsSubject.eraseToAnyPublisher()
    }
}
