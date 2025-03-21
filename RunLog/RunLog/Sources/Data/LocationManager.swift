//
//  LocationManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Combine

final class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: - Singleton
    static let shared = LocationManager()
    // MARK: - Properties
    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    var currentLocation: CLLocation {
        // 현재 위치를 반환, 못찾으면 서울을 기본값으로 반환
        return locationManager.location ?? CLLocation(latitude: 37.5665, longitude: 126.9780)
    }
    // GPS 값 검증을 위한 이전 위치
    private var previousLocation: CLLocation?
    // MARK: - Subjects
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private let locationNameSubject = PassthroughSubject<(CLLocation,CLPlacemark), Never>()
    // MARK: - Publishers
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    var locationNamePublisher: AnyPublisher<(CLLocation,CLPlacemark), Never> {
        locationNameSubject.eraseToAnyPublisher()
    }
    // MARK: - Init
    private override init() {
        super.init()
        setupLocationManager()
    }
    deinit {
        locationManager.stopUpdatingLocation()
    }
    // MARK: - CLLocationManager 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5  // Q) 지피티 피셜 걷기+달리기면 5m가 적당하다 - 실제로 3, 5로 해서 측정해보고 결정
        locationManager.allowsBackgroundLocationUpdates = true // 백그라운드 상태에서도 위치 업데이트
        locationManager.pausesLocationUpdatesAutomatically = true //사용자가 멈춰있으면 업데이트 일시정지
        getLocationUsagePermission()
    }
    // MARK: - 사용자가 위치를 이동하면 위치를 뿌려줌
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        // GPS 신호가 불안정한 경우 필터링
        if previousLocation != nil && (location.horizontalAccuracy < 0 || location.horizontalAccuracy > 10) {
            print("GPS 신호 불안정 - 위치 무시")
            return
        }
        // 이전 위치와 비교하여 1m 이하 이동 시 무시
        if let previous = previousLocation, location.distance(from: previous) < 1 {
            print("이동 거리 1m 이하 - 위치 업데이트 안함")
            return
        }
        self.previousLocation = location
        self.fetchCityName(location: location)
        self.locationSubject.send(location)
    }
}
// MARK: - 도시명 가져오기
extension LocationManager {
    // MARK: - 도시명 가져오기
    private func fetchCityName(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) {
            [weak self] placemarks, error in
            guard let self = self else { return }
            guard let placemark = placemarks?.first else {
                print("Geocoding 실패: \(error!.localizedDescription)")
                return
            }
            self.locationNameSubject.send((location, placemark))
        }
    }
}
// MARK: - 위치 정보 권한 요청
extension LocationManager {
    // MARK: - 권한 정보가 바뀌면 실행
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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




// MARK: - 테스트용 더미 셋
extension LocationManager {
    func setDummy(location: CLLocation) {
        self.previousLocation = location
        self.fetchCityName(location: location)
        self.locationSubject.send(location)
    }
}
