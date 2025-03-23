//
//  DistanceManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/21/25.
//

import Foundation
import Combine
import CoreLocation

final class DistanceManager {
    
    // MARK: - Singleton
    static let shared = DistanceManager()
    private init() {
        bind()
    }
    
    
    // MARK: - Input
    enum Input {
        case requestDistance(previous: CLLocation, current: CLLocation)
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responseDistance(Double)
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        self.input
            .sink { [weak self] input in
                switch input {
                case .requestDistance(let previous, let current):
                    self?.calculateDistance(
                        previous: previous,
                        current: current
                    )
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 이동 거리를 계산해서 output으로 send
    private func calculateDistance(previous: CLLocation, current: CLLocation) {
        let distance = current.distance(from: previous)
        if distance >= 1 {
            self.output.send(.responseDistance(distance))
        }
    }
}

