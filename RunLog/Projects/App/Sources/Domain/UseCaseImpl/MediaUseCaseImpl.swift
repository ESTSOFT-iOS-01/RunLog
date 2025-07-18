//
//  MediaUseCaseImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import UIKit
import MapKit
import CoreLocation

final class MediaUseCaseImpl: MediaUseCase {

    init() {}

    func convertSectionsToCoordinates(sections: [Section]) -> [[CLLocationCoordinate2D]] {
        var coordinates = [[CLLocationCoordinate2D]]()

        for section in sections {
            var coors = [CLLocationCoordinate2D]()
            for point in section.route.sorted(by: { $0.timestamp < $1.timestamp }) {
                let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                coors.append(coordinate)
            }
            coordinates.append(coors)
        }

        return coordinates
    }
    
    func setRouteImage(route coordinates: [[CLLocationCoordinate2D]]) async throws -> UIImage {
        let flatCoordinates = coordinates.flatMap { $0 }
        let centerCoordinate = try getRouteCenterCoordinate(flatCoordinates)
        let region = makeRouteSizeRegion(center: centerCoordinate, coordinates: flatCoordinates)

        // 스냅샷 옵션 설정
        let option = setSnapshotOption(region: region)
        let snapShotter = MKMapSnapshotter(options: option)

        // 스냅샷 생성 (비동기 처리)
        let snapshot: MKMapSnapshotter.Snapshot? = await withCheckedContinuation { continuation in
            snapShotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: snapshot)
            }
        }

        guard let snapshot = snapshot else {
            throw MediaUseCaseError.snapshotFailed
        }

        let mapImage = snapshot.image

        // 이미지 위에 경로 그리기
        let overlayImage = UIGraphicsImageRenderer(size: mapImage.size).image { context in
            mapImage.draw(at: .zero)

            for route in coordinates {
                let points = route.map { snapshot.point(for: $0) }
                let path = UIBezierPath()
                path.move(to: points.first ?? .zero)

                for point in points.dropFirst() {
                    path.addLine(to: point)
                }

                path.lineWidth = 2
                UIColor.LightGreen.setStroke()
                path.stroke()
            }
        }

        return overlayImage
    }
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws {
        guard let imageData = image.pngData() else {
            throw NSError(domain: "com.estsoft.runlog", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"])
        }

        let fileManager = FileManager.default
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = documentDirectory.appendingPathComponent(imageName)

        try imageData.write(to: fileURL)
    }
    
    // MARK: - private funcs
    
    // 스냅샷 옵션 설정
    private func setSnapshotOption(region: MKCoordinateRegion) -> MKMapSnapshotter.Options {
        let option = MKMapSnapshotter.Options()
        option.region = region
        option.size = CGSize(width: 500, height: 500)

        let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
        configuration.pointOfInterestFilter = .excludingAll
        option.preferredConfiguration = configuration

        return option
    }

    // 경로의 중심 좌표 계산
    private func getRouteCenterCoordinate(_ coordinates: [CLLocationCoordinate2D]) throws -> CLLocationCoordinate2D {
        guard !coordinates.isEmpty else {
            throw MediaUseCaseError.noCenterPos
        }

        var centerLat: CLLocationDegrees = 0
        var centerLon: CLLocationDegrees = 0

        for coordinate in coordinates {
            centerLat += coordinate.latitude
            centerLon += coordinate.longitude
        }

        centerLat /= Double(coordinates.count)
        centerLon /= Double(coordinates.count)

        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }

    // 경로 전체를 포함하는 지도 영역 계산
    private func makeRouteSizeRegion(center: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        // 지도의 확대 비율 계수 (값이 클수록 더 넓은 범위를 포함함)
        // - 이 부분을 바꿔서 이미지를 생성하면 경로와 이미지 사이의 패딩이 생김
        let mapPaddingScale: CLLocationDegrees = 1.7

        let minLat = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let maxLat = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let minLon = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        let maxLon = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 0

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * mapPaddingScale,
            longitudeDelta: (maxLon - minLon) * mapPaddingScale
        )
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
}
