//
//  MKMapView+.swift
//  RunLog
//
//  Created by 심근웅 on 3/18/25.
//

import Foundation
import MapKit

extension MKMapView {
    
    /// 위치와 보여질 거리, 기존에 지정된 카메라위치에 따라 카메라 위치를 지정합니다.
    /// - Parameters:
    ///   - location: 표현하고자하는 위치
    ///   - regionRadius: 최대로 보여질 지도 거리
    ///   - region: 기존 카메라 상태
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 150, // 주변 거리(미터)
        region: MKCoordinateRegion? = nil
    ) {
        
        if let region = region { // 기존의 줌이 존재하면 해당 줌을 유지
            
            let updatedRegion = MKCoordinateRegion(
                center: location.coordinate,
                span: region.span // 기존 줌(span) 유지
            )
            setRegion(updatedRegion, animated: true)
            
        } else { // 기존 줌이 존재하지 않다면 거리에 대비해 카메라 줌을 조정
            
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            setRegion(coordinateRegion, animated: true)
            
        }
        
        let currentCamera = self.camera
        let updatedCamera = MKMapCamera(
            lookingAtCenter: location.coordinate,
            fromDistance: currentCamera.centerCoordinateDistance, // 기존 줌 유지
            pitch: currentCamera.pitch,  // 기울기 유지
            heading: currentCamera.heading // 회전 유지
        )
        self.setCamera(updatedCamera, animated: true)
    }
    
    // MARK: - 초기 카메라 위치 세팅 - 좌표: 서울
    func initZoomLevel(_ meters: CLLocationDistance =  150) {
        let newRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.5665,
                longitude: 126.9780
            ),
            latitudinalMeters: meters,
            longitudinalMeters: meters
        )
        setRegion(newRegion, animated: false)
    }
}
