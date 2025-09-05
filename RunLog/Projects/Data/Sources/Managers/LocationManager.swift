//
//  LocationManager.swift
//  RLData
//
//  Created by 신승재 on 8/18/25.
//  Copyright © 2025 ESTSOFTiOSTEAM1. All rights reserved.
//

import RLDomain

import Foundation
import Combine
import CoreLocation


public final class LocationManager: NSObject, LocationProvider {
    
    private let locationManager = CLLocationManager()
    private let currentLocation = CurrentValueSubject<CLLocation?, Never>(nil)
    
    public override init() {
        super.init()
        setup()
    }
    
    private func setup() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 4
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    public func startUpdating() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
    
    public var locations: AnyPublisher<CLLocation, Never> {
        currentLocation.compactMap { $0 }.eraseToAnyPublisher()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let latestLocation = locations.last else { return }
        
        if currentLocation.value == nil {
            currentLocation.send(latestLocation)
            return
        }
        
        // 0 이상 10이하만 통과(갑자기 확 튀는 현상 방지)
        guard latestLocation.horizontalAccuracy >= 0,
              latestLocation.horizontalAccuracy <= 10 else { return }
        
        // 노이즈 제거
        if let prev = currentLocation.value, latestLocation.distance(from: prev) < 1 { return }
        currentLocation.send(latestLocation)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            break

        case .denied, .restricted:
            break

        @unknown default:
            return
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error:", error.localizedDescription)
    }
}
