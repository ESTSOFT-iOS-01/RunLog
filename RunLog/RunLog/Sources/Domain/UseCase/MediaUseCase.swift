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
    
    func convertSectionsToCoordinates(sections: [Section]) -> [CLLocationCoordinate2D]
    
    func setRouteImage(route coordinates: [CLLocationCoordinate2D])
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws
    
}

// MediaUseCase 관련 에러를 정의
enum MediaUseCaseError: Error {
    case noPolylineFound // 폴리라인이 발견되지 않았을 때 발생하는 에러
    case imageCaptureFailed // 이미지 캡처 실패
}
