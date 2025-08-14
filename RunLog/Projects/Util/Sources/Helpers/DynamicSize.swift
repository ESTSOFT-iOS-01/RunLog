//
//  DynamicSize.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import UIKit
import Foundation

/// 화면 크기에 맞춰 동적으로 사이즈를 조정하는 구조체
///
/// - Note:
///   - 기준 사이즈는 **iPone 16 Pro Max** (440 x 956)
///- `SceneDelegate`에서 `setScreenSize(_:)`를 호출하여 초기 화면 크기를 설정해야 함
public struct DynamicSize {
    
    /// 기준 너비 (16 Pro Max)
    private static let baseWidth: CGFloat = 440
    /// 기준 높이 (16 Pro Max)
    private static let baseHeight: CGFloat = 956
    /// 기준 대각선 길이
    private static let baseDiagonal: CGFloat = sqrt(baseWidth * baseWidth + baseHeight * baseHeight)
    
    ///  화면 크기 저장 (기본값: 440x956)
    ///
    ///   - Note: `SceneDelegate` 에서 `setScreenSize(_ :)` 를 호출해 업데이트 필요
    private static var bounds: CGRect = CGRect(x: 0, y: 0, width: baseWidth, height: baseHeight)
    
    /// 현재 화면 크기 설정
    ///
    /// - Parameter newBounds: 새롭게 설정할 화면의 `CGRect` 크기
    public static func setScreenSize(_ newBounds: CGRect) {
        self.bounds = newBounds
    }
    
    /// 기기 화면 너비
    static var screenWidth: CGFloat {
        return bounds.width
    }
    
    /// 기기 화면 높이 반환
    static var screenHeight: CGFloat {
        return bounds.height
    }
    
    /// 기기 화면 전체 크기
    static var screenBounds: CGRect {
        return bounds
    }
}

// MARK: - Dynamic Size
extension DynamicSize {
    
    /// 대각선 비율 기반의 다이나믹 스케일 값
    static var scaleFactor: CGFloat {
        let currentDiagonal = sqrt(screenWidth * screenWidth + screenHeight * screenHeight)
        return currentDiagonal / baseDiagonal
    }
    
    /// 주어진 값에 스케일 비율을 적용
    public static func scaledSize(_ size: CGFloat) -> CGFloat {
        return size * scaleFactor
    }
}
