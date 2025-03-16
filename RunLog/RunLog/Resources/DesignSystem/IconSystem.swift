//
//  IconSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import Foundation

// MARK: - 아이콘
enum RLIcon {
    case foldButton
    case weather
    case unfoldButton
}

extension RLIcon {
    var name: String {
        switch self {
        case .foldButton:
            return "xmark"
        case .unfoldButton:
            return "heart.text.square"
        case .weather:
            return "thermometer.medium"
        }
    }
}
