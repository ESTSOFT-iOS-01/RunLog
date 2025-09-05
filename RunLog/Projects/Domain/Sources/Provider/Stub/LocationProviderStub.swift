//
//  LocationProviderStub.swift
//  RLDomain
//
//  Created by 신승재 on 8/28/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

public final class LocationProviderStub: LocationProvider {
    private let subject = PassthroughSubject<CLLocation, Never>()
    private(set) public var isUpdating = false
    private var task: Task<Void, Never>?

    public init() {}

    public func startUpdating() {
        isUpdating = true
        self.play(route: [
            CLLocation(latitude: 37.5665, longitude: 126.9780),
            CLLocation(latitude: 37.5665, longitude: 126.97805),
            CLLocation(latitude: 37.5665, longitude: 126.97810),
            CLLocation(latitude: 37.5665, longitude: 126.97815),
            CLLocation(latitude: 37.5665, longitude: 126.97820),
            CLLocation(latitude: 37.5665, longitude: 126.97825),
            CLLocation(latitude: 37.5665, longitude: 126.97830),
            CLLocation(latitude: 37.5665, longitude: 126.97835),
            CLLocation(latitude: 37.5665, longitude: 126.97840),
            CLLocation(latitude: 37.5665, longitude: 126.97845),
            CLLocation(latitude: 37.5665, longitude: 126.97850),
            CLLocation(latitude: 37.5665, longitude: 126.97855),
            CLLocation(latitude: 37.5665, longitude: 126.97860),
            CLLocation(latitude: 37.5665, longitude: 126.97865),
            CLLocation(latitude: 37.5665, longitude: 126.97870),
            CLLocation(latitude: 37.5665, longitude: 126.97875),
            CLLocation(latitude: 37.5665, longitude: 126.97880),
            CLLocation(latitude: 37.5665, longitude: 126.97885),
            CLLocation(latitude: 37.5665, longitude: 126.97890),
            CLLocation(latitude: 37.5665, longitude: 126.97895),
            CLLocation(latitude: 37.5665, longitude: 126.97900)
        ])
    }
    
    public func stopUpdating()  {
        isUpdating = false
        task?.cancel()
        task = nil
    }

    public var locations: AnyPublisher<CLLocation, Never> {
        subject.eraseToAnyPublisher()
    }
    
    private func play(route: [CLLocation], interval: TimeInterval = 2) {
        task?.cancel()
        guard isUpdating else { return }
        task = Task {
            for loc in route {
                if Task.isCancelled { break }
                subject.send(loc)
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }
}
