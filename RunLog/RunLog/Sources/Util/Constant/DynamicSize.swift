//
//  UIWindowScene+.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import Foundation
import UIKit

struct DynamicSize {
    /// 기존 디자인 기준 대각선 길이 (iPhone 16 Pro Max: 440 x 956)
    private static let baseDiagonal: CGFloat = sqrt(440 * 440 + 956 * 956)
    
}

// MARK: - 대각선 크기로 변환
extension DynamicSize {
    
    /// 현재 기기의 대각선 길이 계산
    private static var currentDiagonal: CGFloat {
        let width = ScreenSizeManager.shared.screenWidth
        let height = ScreenSizeManager.shared.screenHeight
        return sqrt(width * width + height * height)
    }
    
    /// 🔄 **전체적인 크기 조정 비율**
    static var scaleFactor: CGFloat {
        return currentDiagonal / baseDiagonal
    }
    
    /// 📌 **화면 크기에 맞춰 비율 조정된 사이즈 반환**
    static func getSize(_ size: CGFloat) -> CGFloat {
        return size * scaleFactor
    }
}

// MARK: - 가로, 세로 따로 변환
extension DynamicSize {
    /// 주어진 높이를 화면 비율에 맞게 변환
    static func getHeight(_ size: CGFloat) -> CGFloat {
        return size * ScreenSizeManager.shared.screenHeight / 956
    }
    
    /// 주어진 너비를 화면 비율에 맞게 변환
    static func getWidth(_ size: CGFloat) -> CGFloat {
        return size * ScreenSizeManager.shared.screenWidth / 440
    }
}
