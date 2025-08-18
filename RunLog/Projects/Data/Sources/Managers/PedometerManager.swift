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

public final class PedometerManager: PedometerProvider {
    
    private let pedometer = CMPedometer()
    private let currentSteps = PassthroughSubject<Int, Never>()
    
    public init() { }
    
    public func startPedometer() {
        guard CMPedometer.isStepCountingAvailable() else {
            return
        }

        pedometer.startUpdates(from: Date()) { [weak self] data, error in
            if let error { print(error) }
            guard let data = data else { return }
            self?.currentSteps.send(data.numberOfSteps.intValue)
        }
    }

    public func stopPedometer() {
        pedometer.stopUpdates()
    }
    
    public var steps: AnyPublisher<Int, Never> {
        currentSteps.eraseToAnyPublisher()
    }
}
