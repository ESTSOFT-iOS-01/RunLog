//
//  MediaUseCaseImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import UIKit
import MapKit

final class MediaUseCaseImpl: MediaUseCase {

    init() {
    }

    // 폴리라인을 캡처하는 함수
//    func createPolylineImage(mapView: MKMapView) async throws -> UIImage {
//        // 1. 폴리라인을 맵뷰의 overlays에서 찾기
//        guard let polyline = await mapView.overlays.compactMap({ $0 as? MKPolyline }).first else {
//            throw MediaUseCaseError.noPolylineFound
//        }
//        
//        // 2. 폴리라인 렌더러 설정
//        let renderer = MKPolylineRenderer(polyline: polyline)
//        renderer.strokeColor = .white // 폴리라인 색상 설정 (하얀색으로 설정)
//        renderer.lineWidth = 4
//        
//        // 3. 맵뷰 크기와 일치하는 이미지를 생성하는 렌더러
//        let image = try await capturePolylineImage(mapView: mapView, renderer: renderer)
//
//        return image
//    }
    
//    func createPolylineImage(mapView: MKMapView, overlay: MKOverlay) throws -> UIImage {
//        // 1. 폴리라인 렌더러 설정 (overlay를 받아서 MKPolylineRenderer로 렌더링)
//        guard let polyline = overlay as? MKPolyline else {
//            throw MediaUseCaseError.noPolylineFound
//        }
//        
//        let renderer = MKPolylineRenderer(polyline: polyline)
//        renderer.strokeColor = .white // 폴리라인 색상 설정 (하얀색으로 설정)
//        renderer.lineWidth = 4
//
//        // 2. 이미지를 생성하고 반환
//        return try capturePolylineImage(mapView: mapView, renderer: renderer)
//    }
    
    // 2. 실제 폴리라인만 캡처하는 함수
    func createPolylineImage(mapView: MKMapView, overlays: [MKOverlay]) throws -> UIImage {
        // 1. `MKPolyline`만 필터링하여 각 폴리라인을 렌더링
        let polylines = overlays.compactMap { $0 as? MKPolyline }

        // 2. 이미지를 생성할 렌더러
        let imageRenderer = UIGraphicsImageRenderer(size: mapView.bounds.size)

        return imageRenderer.image { context in
            // 배경을 투명하게 설정 (기본적으로 배경이 투명하게 설정됨)
            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.fill(mapView.bounds)

            // 3. 폴리라인을 그리기
            for polyline in polylines {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .white  // 폴리라인 색상 설정
                renderer.lineWidth = 1

                // 폴리라인을 그리기 위한 mapRect와 zoomScale 계산
                let mapRect = mapView.visibleMapRect
                let zoomScale = mapView.bounds.width / mapView.visibleMapRect.size.width
                
                renderer.draw(mapRect, zoomScale: zoomScale, in: context.cgContext)
            }
        }
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
    
    // 4. 이미지 생성 후 저장하는 함수
    func createAndSaveImage(mapView: MKMapView, overlays: [MKOverlay]) throws {
        let image = try createPolylineImage(mapView: mapView, overlays: overlays)
        print("이미지 생성 성공")
        
        // 임시로 "polyline_image.png"로 저장
        try saveImageToDocuments(image: image, imageName: "polyline_image.png")
    }
    
//    func createAndSaveImage(mapView: MKMapView) async throws {
//        let image = try await createPolylineImage(mapView: mapView)
//        print("이미지 생성 성공")
//        // 임시로 "polyline_image.png"로 저장
//        try saveImageToDocuments(image: image, imageName: "polyline_image.png")
//    }
    
    func createPolylineAnimationVideo(polyline: MKPolyline, mapView: MKMapView, videoDuration: Double) async throws -> URL {
        // 애니메이션 영상 생성 로직
        return try await withCheckedThrowingContinuation { continuation in
            // 영상 생성 로직
        }
    }
    
    func saveVideoToStorage(videoURL: URL, saveToLibrary: Bool) async throws -> Bool {
        // 영상 저장 로직
        return try await withCheckedThrowingContinuation { continuation in
            // 저장 로직
        }
    }
    
}
