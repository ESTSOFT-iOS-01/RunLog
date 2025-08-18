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
    private let currentLocation = PassthroughSubject<CLLocation, Never>()
    private var previousLocation: CLLocation?
    
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
        currentLocation.eraseToAnyPublisher()
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
        
        // 0 이상 10이하만 통과(갑자기 확 튀는 현상 방지)
        guard latestLocation.horizontalAccuracy >= 0,
              latestLocation.horizontalAccuracy <= 10 else { return }
        
        // 노이즈 제거
        if let previousLocation, latestLocation.distance(from: previousLocation) < 10 { return }
        
        currentLocation.send(latestLocation)
        previousLocation = latestLocation
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()

        case .authorizedAlways:
            locationManager.startUpdatingLocation()

        case .denied, .restricted:
            locationManager.stopUpdatingLocation()

        @unknown default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager error:", error.localizedDescription)
    }
}
