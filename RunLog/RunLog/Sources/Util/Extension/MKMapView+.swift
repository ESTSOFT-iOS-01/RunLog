//
//  MKMapView+.swift
//  RunLog
//
//  Created by 심근웅 on 3/18/25.
//

import Foundation
import MapKit

extension MKMapView {
    // MARK: - 카메라 위치 변경
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 150, // 주변 거리(미터)
        region: MKCoordinateRegion? = nil
    ) {
        if let region = region {
            let updatedRegion = MKCoordinateRegion(
                center: location.coordinate,
                span: region.span // 기존 줌(span) 유지
            )
            setRegion(updatedRegion, animated: true)
        } else {
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
