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
    
    func convertSectionsToCoordinates(sections: [Section]) -> [[CLLocationCoordinate2D]]
    
    func setRouteImage(route coordinates: [[CLLocationCoordinate2D]]) async throws -> UIImage
    
    func saveImageToDocuments(image: UIImage, imageName: String) throws
    
}

// MediaUseCase 관련 에러를 정의
enum MediaUseCaseError: Error {
    case snapshotFailed // 이미지 캡처 실패
    case noCenterPos // 이미지 캡처 실패
}

extension MediaUseCaseError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noCenterPos:
            return "중심 좌표가 없습니다."
        case .snapshotFailed:
            return "스냅샷 생성에 실패하였습니다."
        }
    }
}
