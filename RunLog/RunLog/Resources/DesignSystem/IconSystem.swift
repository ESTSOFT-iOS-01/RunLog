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
    case weather
}

extension RLIcon {
    var name: String {
        switch self {
        case .closeButton:
            return "xmark"
        case .weather:
            return "thermometer.medium"
        }
    }
}
