//
//  IconSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import Foundation

// MARK: - 아이콘
enum RLIcon {
    case document
    case streak
    case rightArrow
    case fold
    case weather
    case unfold
}

extension RLIcon {
    var name: String {
        switch self {
        case .fold:
            return "xmark"
        case .document:
            return "text.document"
        case .streak:
            return "leaf"
        case .rightArrow:
            return "chevron.right"
        case .unfold:
            return "heart.text.square"
        case .weather:
            return "thermometer.medium"
        }
    }
}
