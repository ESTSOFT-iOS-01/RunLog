//
//  MediaUseCase.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import UIKit
import MapKit

/// `MediaUseCase` 프로토콜은 폴리라인을 이미지 또는 영상으로 변환하여 저장하는 기능을 제공합니다.
protocol MediaUseCase {
    
    /// 폴리라인을 이미지로 생성합니다.
    ///
    /// - Parameters:
    ///   - mapView: 폴리라인을 그린 맵 뷰
    /// - Returns: 생성된 이미지 (`UIImage`)
    /// - Throws: 이미지 생성 중 발생할 수 있는 에러
    func createPolylineImage(mapView: MKMapView) async throws -> UIImage
    
    /// 폴리라인 애니메이션을 영상으로 생성합니다.
    ///
    /// - Parameters:
    ///   - polyline: 애니메이션이 적용될 폴리라인
    ///   - mapView: 애니메이션을 적용할 맵 뷰
    ///   - videoDuration: 영상 길이 (초 단위)
    /// - Returns: 생성된 영상 파일 (`URL`)
    /// - Throws: 영상 생성 중 발생할 수 있는 에러
//    func createPolylineAnimationVideo(polyline: MKPolyline, mapView: MKMapView, videoDuration: Double) async throws -> URL
    
    /// 폴리라인 애니메이션 영상을 사용자 라이브러리 또는 지정된 저장소에 저장합니다.
    ///
    /// - Parameters:
    ///   - videoURL: 저장할 영상의 URL
    ///   - saveToLibrary: `true`일 경우 사용자 라이브러리에 저장, `false`일 경우 다른 저장소에 저장
    /// - Returns: 저장 성공 여부 (`true` or `false`)
    /// - Throws: 저장 중 발생할 수 있는 에러
//    func saveVideoToStorage(videoURL: URL, saveToLibrary: Bool) async throws -> Bool
}

// MediaUseCase 관련 에러를 정의
enum MediaUseCaseError: Error {
    case noPolylineFound // 폴리라인이 발견되지 않았을 때 발생하는 에러
    case imageCaptureFailed // 이미지 캡처 실패
}
