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
    // MARK: - Input & Output
    enum Input {
        case requestDistance(CLLocation, CLLocation)
    }
    enum Output {
        case responseDistance(Double)
    }
    let input = PassthroughSubject<Input, Never>()
    let output = PassthroughSubject<Output, Never>()
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Init
    private init() {
        bind()
    }
    // MARK: - Bind (Input -> Output)
    private func bind() {
        self.input
            .sink { [weak self] input in
                switch input {
                case .requestDistance(let location, let previous):
                    self?.calculateDistance(
                        location: location,
                        previous: previous
                    )
                }
                
            }
            .store(in: &cancellables)
    }
}
// MARK: - 거리 계산
extension DistanceManager {
    // 이동 거리를 측정해서 output으로 send
    private func calculateDistance(location: CLLocation, previous: CLLocation) {
        let distance = location.distance(from: previous)
        if distance >= 1 {
            output.send(.responseDistance(distance))
        }
    }
}

