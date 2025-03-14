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
        }
    }
}
