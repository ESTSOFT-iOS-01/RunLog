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
    
    /// 현재 기기의 대각선 길이 계산
    private static var currentDiagonal: CGFloat {
        let width = ScreenSizeManager.shared.screenWidth
        let height = ScreenSizeManager.shared.screenHeight
        return sqrt(width * width + height * height)
    }
    
    /// 크기 조정 비율
    static var scaleFactor: CGFloat {
        return currentDiagonal / baseDiagonal
    }
    
    /// 주어진 크기를 화면 비율에 맞게 변환 (높이, 너비, 폰트 크기 공통)
    static func scaledSize(_ size: CGFloat) -> CGFloat {
        return size * scaleFactor
    }
}
