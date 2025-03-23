//
//  UIWindowScene+.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import Foundation
import UIKit

extension UIWindowScene {
    /// 현재 활성화된 `UIWindowScene` 반환
    private static var current: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    /// 기기 화면 너비
    static var screenWidth: CGFloat {
        current?.screen.bounds.width ?? 440
    }
    
    /// 기기 화면 높이
    static var screenHeight: CGFloat {
        current?.screen.bounds.height ?? 956
    }
    
    /// 기기 화면 전체 크기
    static var screenBounds: CGRect {
        current?.screen.bounds ?? CGRect(x: 0, y: 0, width: 440, height: 956)
    }
}

struct DynamicPadding {
    /// 주어진 높이를 화면 비율에 맞게 변환
    static func getHeight(_ size: CGFloat) -> CGFloat {
        return size * UIWindowScene.screenHeight / 956
    }
    
    /// 주어진 너비를 화면 비율에 맞게 변환
    static func getWidth(_ size: CGFloat) -> CGFloat {
        return size * UIWindowScene.screenWidth / 440
    }
}
