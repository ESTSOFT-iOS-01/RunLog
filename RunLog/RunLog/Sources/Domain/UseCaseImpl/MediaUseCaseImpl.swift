//
//  MediaUseCaseImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import UIKit
import MapKit

final class MediaUseCaseImpl: MediaUseCase {
    
    private let renderer: MKPolylineRenderer

    init(renderer: MKPolylineRenderer) {
        self.renderer = renderer
    }

    // 폴리라인을 캡처하는 함수
    func createPolylineImage(mapView: MKMapView) async throws -> UIImage {
        // 1. 폴리라인을 맵뷰의 overlays에서 찾기
        guard let polyline = await mapView.overlays.compactMap({ $0 as? MKPolyline }).first else {
            throw MediaUseCaseError.noPolylineFound
        }
        
        // 2. 폴리라인 렌더러 설정
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .white // 폴리라인 색상 설정 (하얀색으로 설정)
        renderer.lineWidth = 4
        
        // 3. 맵뷰 크기와 일치하는 이미지를 생성하는 렌더러
        let image = try await capturePolylineImage(mapView: mapView, renderer: renderer)

        return image
    }
    
    private func capturePolylineImage(mapView: MKMapView, renderer: MKPolylineRenderer) async throws -> UIImage {
        // `UIGraphicsImageRenderer`를 사용하여 이미지를 생성
        let imageRenderer = await UIGraphicsImageRenderer(size: mapView.bounds.size)
        
        return imageRenderer.image { context in
            // 배경을 투명으로 설정
            context.cgContext.setFillColor(UIColor.black.cgColor)
            context.cgContext.fill(mapView.bounds)
            
            let mapRect = mapView.visibleMapRect
            let zoomScale = mapView.bounds.width / mapView.visibleMapRect.size.width
            
            // 폴리라인을 그리기
            renderer.draw(mapRect, zoomScale: zoomScale, in: context.cgContext)
        }
    }
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws {
        // 1. 이미지 데이터를 PNG로 변환
        guard let imageData = image.pngData() else {
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
    
    func createAndSaveImage(mapView: MKMapView) async throws {
        let image = try await createPolylineImage(mapView: mapView)
        
        // 임시로 "polyline_image.png"로 저장
        try saveImageToDocuments(image: image, imageName: "polyline_image.png")
    }
    
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
