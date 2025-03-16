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
    case foldButton
    case weather
    case unfoldButton
}

extension RLIcon {
    var name: String {
        switch self {
        case .foldButton:
            return "xmark"
        case .document:
            return "text.document"
        case .streak:
            return "leaf"
        case .rightArrow:
            return "chevron.right"
        case .unfoldButton:
            return "heart.text.square"
        case .weather:
            return "thermometer.medium"
        }
    }
}
