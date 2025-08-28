//
//  LocationProvider.swift
//  RLDomain
//
//  Created by 신승재 on 8/16/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

public protocol LocationProvider {
    func startUpdating()
    func stopUpdating()
    var locations: AnyPublisher<CLLocation, Never> { get }
}
