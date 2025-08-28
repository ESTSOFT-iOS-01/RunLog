//
//  PedometerProvider.swift
//  RLDomain
//
//  Created by 신승재 on 8/15/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import Foundation
import Combine

public protocol PedometerProvider {
    func startPedometer()
    func stopPedometer()
    var steps: AnyPublisher<Int, Never> { get }
}
