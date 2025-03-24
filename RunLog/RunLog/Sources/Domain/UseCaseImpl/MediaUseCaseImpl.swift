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

    init() {
    }
    
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
        let centerCoordinate = try getRouteCenterCoordinate(coordinates.flatMap { $0 })
        let region = makeRouteSizeRegion(center: centerCoordinate, coordinates: coordinates.flatMap { $0 })
        
        /// 스냅샷 옵션 설정
        let option = setSnapshotOption(coordinates.flatMap { $0 }, region: region)
        let snapShotter = MKMapSnapshotter(options: option)

        /// 스냅샷 생성
        let snapshot : MKMapSnapshotter.Snapshot? = await withCheckedContinuation { continuation in
            snapShotter.start { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    print("Error: \(String(describing: error))")
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
        let overlayImage = UIGraphicsImageRenderer(size: mapImage.size).image { context in
            mapImage.draw(at: .zero)
            
            for route in coordinates {
                let points = route.map { snapshot.point(for: $0) }
                let path = UIBezierPath()
                path.move(to: points.first ?? CGPoint(x: 0, y: 0))
                
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
    
    
//    func convertSectionsToCoordinates(sections: [Section]) -> [CLLocationCoordinate2D] {
//        var coordinates: [CLLocationCoordinate2D] = []
//
//        for section in sections {
//            for point in section.route.sorted(by: { $0.timestamp < $1.timestamp }) {
//                let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
//                coordinates.append(coordinate)
//            }
//        }
//        
//        return coordinates
//    }
    

//    func setRouteImage(route coordinates: [CLLocationCoordinate2D]) -> UIImage? {
//        guard let centerCoordinate = getRouteCenterCoordinate(coordinates) else { return nil }
//        let region = makeRouteSizeRegion(center: centerCoordinate, coordinates: coordinates)
//        
//        let option = setSnapshotOption(coordinates, region: region)
//        let snapShotter = MKMapSnapshotter(options: option)
//        
//        snapShotter.start { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                print("Error: \(String(describing: error))")
//                return
//            }
//            
//            let mapImage = snapshot.image
//            let overlayImage = UIGraphicsImageRenderer(size: mapImage.size).image { context in
//                mapImage.draw(at: .zero)
//                let points = coordinates.map { snapshot.point(for: $0) }
//                let path = UIBezierPath()
//                path.move(to: points.first ?? CGPoint(x: 0, y: 0))
//                
//                for point in points.dropFirst() {
//                    path.addLine(to: point)
//                }
//                
//                path.lineWidth = 1
//                UIColor.LightGreen.setStroke()
//                path.stroke()
//            }
//            
//            // 임시 저장: 생성된 이미지 처리 후 저장
////            do {
////                try self.saveImageToDocuments(image: overlayImage, imageName: "route_image.png")
////            } catch {
////                print("Error saving image: \(error)")
////            }
//            return overlayImage
//        }
//    }
    
    private func setSnapshotOption(_ coordinates: [CLLocationCoordinate2D], region: MKCoordinateRegion) -> MKMapSnapshotter.Options {
        let option = MKMapSnapshotter.Options()
        option.region = region
        option.size = CGSize(width: 500, height: 500) // 원하는 이미지 크기 설정
        
        let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
        configuration.pointOfInterestFilter = .excludingAll
        option.preferredConfiguration = configuration
        return option
    }
    
    // 옵션 설정
    private func setSnapshotOption(_ coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options {
        let option = MKMapSnapshotter.Options()
        
        let configuration = MKStandardMapConfiguration(emphasisStyle: .muted)
        configuration.pointOfInterestFilter = .excludingAll
        option.preferredConfiguration = configuration
        
        return option
    }
    
    // 지도 중점 구하기
    private func getRouteCenterCoordinate(_ coordinates: [CLLocationCoordinate2D]) throws -> CLLocationCoordinate2D {
        guard coordinates.isEmpty == false || coordinates.count > 1 else {
            throw MediaUseCaseError.noCenterPos
        }
        
        var centerLat : CLLocationDegrees = 0
        var centerLon : CLLocationDegrees = 0
        
        for coordinate in coordinates {
            centerLat += coordinate.latitude
            centerLon += coordinate.longitude
        }
        
        centerLat /= Double(coordinates.count)
        centerLon /= Double(coordinates.count)
        
//        print("중점 x: \(centerLat)")
//        print("중점 y: \(centerLon)")
        
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
    
    private func makeRouteSizeRegion(center: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        
        let minLat = coordinates.min { $0.latitude < $1.latitude }?.latitude ?? 0
        let maxLat = coordinates.max { $0.latitude < $1.latitude }?.latitude ?? 0
        let minLon = coordinates.min { $0.longitude < $1.longitude }?.longitude ?? 0
        let maxLon = coordinates.max { $0.longitude < $1.longitude }?.longitude ?? 0
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.7, longitudeDelta: (maxLon - minLon)*1.7)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws {
    print("이미지 크기: \(image.size)")
    guard let imageData = image.pngData() else {
        print("이미지 데이터를 PNG로 변환할 수 없습니다.")
        throw NSError(domain: "com.estsoft.runlog", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환 실패"])
    }
    
    // 2. 도큐먼트 디렉토리 경로 가져오기
    let fileManager = FileManager.default
    let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    // 3. 이미지 파일 경로
    let fileURL = documentDirectory.appendingPathComponent(imageName)
    
    // 4. 이미지 파일 저장
    try imageData.write(to: fileURL)
    print("이미지 저장 완료: \(fileURL.path)")
}
    
}
