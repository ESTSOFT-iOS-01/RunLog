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
        }else {
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            setRegion(coordinateRegion, animated: true)
        }
    }
}
