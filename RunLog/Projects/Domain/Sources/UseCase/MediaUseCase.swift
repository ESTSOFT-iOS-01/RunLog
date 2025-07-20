//
//  MediaUseCase.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import UIKit
import MapKit

/// 미디어 관련 유스케이스를 정의하는 프로토콜입니다.
/// 주어진 경로 데이터를 이미지로 변환하거나 저장하는 기능을 제공합니다.
public protocol MediaUseCase {
    
    /// 주어진 섹션 데이터를 CLLocationCoordinate2D 좌표 배열로 변환합니다.
    /// - Parameter sections: 위치 정보를 포함하는 섹션 배열
    /// - Returns: 각 섹션별 CLLocationCoordinate2D 배열의 배열
    func convertSectionsToCoordinates(sections: [Section]) -> [[CLLocationCoordinate2D]]
    
    /// 주어진 좌표 정보를 기반으로 경로 이미지를 생성합니다.
    /// - Parameter coordinates: 섹션별 좌표 배열
    /// - Returns: 생성된 경로 이미지
    func setRouteImage(route coordinates: [[CLLocationCoordinate2D]]) async throws -> UIImage
    
    /// 이미지를 앱의 Document 디렉터리에 저장합니다.
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - imageName: 저장할 파일 이름
    func saveImageToDocuments(image: UIImage, imageName: String) throws
    
}
