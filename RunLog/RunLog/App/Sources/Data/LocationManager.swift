//
//  LocationManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.

import Foundation
import UIKit
import MapKit
import CoreLocation
import Combine

/// 사용자의 위치 정보를 받아오는 매니저
final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    private override init() {
        super.init()
        setupLocationManager()
        bind()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    
    // MARK: - Input
    enum Input {
        case requestCurrentLocation
        case requestCityName(CLLocation) // 도시이름을 요청
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case locationUpdate(CLLocation) // 현재위치(CLLocatio)를 제공
        case responseCityName(CLPlacemark) // 도시이름(String)을 제공
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var locationManager = CLLocationManager()
    private var previousLocation: CLLocation? // GPS 값 검증을 위한 이전 위치
    
    
    // MARK: - Binding
    private func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestCurrentLocation:
                    guard let location = self.locationManager.location else { return }
                    self.output.send(.locationUpdate(location))
                    
                case .requestCityName(let location):
                    self.fetchCityName(location: location)
                }
            }
            .store(in: &cancellables)
    }
    
    /// CLLocationManager 기본 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 4미터 이동 시 사용자의 위치를 받아옴
        locationManager.distanceFilter = 4
        // 백그라운드 상태에서도 위치 업데이트
        locationManager.allowsBackgroundLocationUpdates = true
        // 사용자가 멈춰있으면 업데이트 일시정지
        locationManager.pausesLocationUpdatesAutomatically = true
        // 사용자의 위치 정보 권한 확인
        getLocationUsagePermission()
    }
}

// MARK: - 사용자 위치 데이터
extension LocationManager {
    
    /// 사용자의 위치를 받아오는 Delegate 함수
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        
        // GPS 신호가 불안정한 경우 필터링
        if previousLocation != nil &&
            (location.horizontalAccuracy < 0 ||
             location.horizontalAccuracy > 10)
        {
            print("GPS 신호 불안정 - 위치 무시")
            return
        }
        
        // 이전 위치와 비교하여 1m 이하 이동 시 무시 - 위치가 튀는것을 방지
        if let previous = previousLocation,
           location.distance(from: previous) < 1
        {
            print("이동 거리 1m 이하 - 위치 업데이트 안함")
            return
        }
        
        // 사용자의 위치를 output으로 send
        self.output.send(.locationUpdate(location))
        // 현재위치를 이전위치로 기억
        previousLocation = location
    }
    
    /// 사용자 위치의 도시명 받아오기
    private func fetchCityName(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {
            [weak self] placemarks, error in
            guard let self = self else { return }
            guard let placemark = placemarks?.first else {
                print("Geocoding 실패: \(error!.localizedDescription)")
                return
            }
            self.output.send(.responseCityName(placemark))
        }
    }
}

// MARK: - 위치 정보 권한 요청
extension LocationManager {
    
    // MARK: - 권한 정보가 바뀌면 실행
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        getLocationUsagePermission()
    }
    
    // MARK: - 권한 정보에 따른 분기 처리
    private func getLocationUsagePermission() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined: // 허용 안한 상태
            locationManager.requestWhenInUseAuthorization()
            
        case .authorizedWhenInUse: // 앱을 사용동안 허용
            locationManager.requestAlwaysAuthorization()
            
        case .restricted, .denied: // 거부 상태
            print("위치 권한이 거부됨 - 설정에서 변경 필요")
            openAppSettings()
            
        case .authorizedAlways: // 항상 허용
            locationManager.startUpdatingLocation()
            
        @unknown default:
            return
        }
    }
    // MARK: - 앱 설정 열기
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
