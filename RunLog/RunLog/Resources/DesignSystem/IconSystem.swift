//
//  IconSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import Foundation

// MARK: - 아이콘
enum RLIcon {
    case closeButton
    case document
    case streak
    case rightArrow
    case play
    case mappin
    case thermometer
    case dumbell
}

extension RLIcon {
    var name: String {
        switch self {
        case .closeButton:
            return "xmark"
        case .document:
            return "text.document"
        case .streak:
            return "leaf"
        case .rightArrow:
            return "chevron.right"
        case .play:
            return "play"
        case .mappin:
            return "mappin.and.ellipse"
        case .thermometer:
            return "thermometer.medium"
        case .dumbell:
            return "dumbbell"
        }
    }
}
