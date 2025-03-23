//
//  UIWindowScene+.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import Foundation
import UIKit

struct DynamicSize {
    /// 주어진 높이를 화면 비율에 맞게 변환
    static func getHeight(_ size: CGFloat) -> CGFloat {
        return size * ScreenSizeManager.shared.screenHeight / 956
    }
    
    /// 주어진 너비를 화면 비율에 맞게 변환
    static func getWidth(_ size: CGFloat) -> CGFloat {
        return size * ScreenSizeManager.shared.screenWidth / 440
    }
}
