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
            CLLocation(latitude: 37.5666, longitude: 126.9782),
            CLLocation(latitude: 37.5667, longitude: 126.9784),
            CLLocation(latitude: 37.5668, longitude: 126.9786),
            CLLocation(latitude: 37.5669, longitude: 126.9788),
            CLLocation(latitude: 37.5670, longitude: 126.9790),
            CLLocation(latitude: 37.5671, longitude: 126.9792),
            CLLocation(latitude: 37.5672, longitude: 126.9790),
            CLLocation(latitude: 37.5673, longitude: 126.9788),
            CLLocation(latitude: 37.5674, longitude: 126.9786),
            CLLocation(latitude: 37.5675, longitude: 126.9784),
            CLLocation(latitude: 37.5676, longitude: 126.9782),
            CLLocation(latitude: 37.5677, longitude: 126.9780),
            CLLocation(latitude: 37.5676, longitude: 126.9778),
            CLLocation(latitude: 37.5675, longitude: 126.9776),
            CLLocation(latitude: 37.5674, longitude: 126.9774),
            CLLocation(latitude: 37.5673, longitude: 126.9772),
            CLLocation(latitude: 37.5672, longitude: 126.9770),
            CLLocation(latitude: 37.5671, longitude: 126.9772),
            CLLocation(latitude: 37.5670, longitude: 126.9774),
            CLLocation(latitude: 37.5669, longitude: 126.9776),
            CLLocation(latitude: 37.5668, longitude: 126.9778),
            CLLocation(latitude: 37.5667, longitude: 126.9780),
            CLLocation(latitude: 37.5666, longitude: 126.9782),
            CLLocation(latitude: 37.5665, longitude: 126.9780)
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
    
    private func play(route: [CLLocation], interval: TimeInterval = 1) {
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
