//
//  ScreenSizeManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import Foundation

/// <#Description#>
struct DynamicSize {
    
    // MARK: - 기준 사이즈 (16 Pro MAX)
    private static let baseWidth: CGFloat = 440
    private static let baseHeight: CGFloat = 956
    private static let baseDiagonal: CGFloat = sqrt(baseWidth * baseWidth + baseHeight * baseHeight)
    
    ///  화면 크기 저장 (기본값: 440x956)
    private static var bounds: CGRect = CGRect(x: 0, y: 0, width: baseWidth, height: baseHeight)
    
    /// 현재 화면 크기 설정 (앱 실행 시 SceneDelegate에서 호출)
    static func setScreenSize(_ newBounds: CGRect) {
        self.bounds = newBounds
    }
    
    /// 기기 화면 너비
    static var screenWidth: CGFloat {
        return bounds.width
    }
    
    /// 기기 화면 높이
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
    static func scaledSize(_ size: CGFloat) -> CGFloat {
        return size * scaleFactor
    }
}
