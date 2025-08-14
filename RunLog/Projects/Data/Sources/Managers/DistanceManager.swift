//
//  DistanceManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/21/25.
//

import Foundation
import Combine
import CoreLocation


/// 사용자가 움직인 거리를 측정하는 매니저
public final class DistanceManager {
    
    // MARK: - Singleton
    public static let shared = DistanceManager()
    private init() {
        bind()
    }
    
    
    // MARK: - Input
    public enum Input {
        case requestDistance(previous: CLLocation, current: CLLocation)
    }
    public let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    public enum Output {
        case responseDistance(Double)
    }
    public let output = PassthroughSubject<Output, Never>()
    
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
    
    /// 이전위치와 현재위치를 전달받아 움직인거리를 output으로 send
    private func calculateDistance(previous: CLLocation, current: CLLocation) {
        let distance = current.distance(from: previous)
        if distance >= 1 {
            self.output.send(.responseDistance(distance))
        }
    }
}

