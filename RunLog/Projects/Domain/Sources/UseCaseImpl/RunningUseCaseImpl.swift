//
//  RunningUseCaseImpl.swift
//  RLDomain
//
//  Created by 신승재 on 8/15/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import Foundation
import Combine

public final class RunningUseCaseImpl: RunningUseCase {
    
    private let pedometerManager: PedometerProvider
    
    init(pedometerManager: PedometerProvider) {
        self.pedometerManager = pedometerManager
    }
    
    public func getSteps() -> AnyPublisher<Int, Never> {
        <#code#>
    }
}
