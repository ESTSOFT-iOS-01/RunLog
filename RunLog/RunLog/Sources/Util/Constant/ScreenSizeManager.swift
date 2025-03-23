//
//  ScreenSizeManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/23/25.
//

import Foundation

final class ScreenSizeManager {
    // MARK: - Singleton
    static let shared = ScreenSizeManager()
    private init() { }
    
    // 화면 크기를 담는 변수
    private var bounds: CGRect = .zero
    
    // 화면 가로 사이즈
    var screenWidth: CGFloat {
        return bounds.width
    }
    
    // 화면 세로 사이즈
    var screenHeight: CGFloat {
        return bounds.height
    }
    
    // 화면 전체 사이즈
    var screenBounds: CGRect {
        return bounds
    }
    
    // 화면 크기를 저장하는 함수
    func setScreenSize(_ bounds: CGRect) {
        self.bounds = bounds
    }
}
