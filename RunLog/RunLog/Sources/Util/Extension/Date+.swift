//
//  Date+.swift
//  RunLog
//
//  Created by 신승재 on 3/17/25.
//

import Foundation

extension Date {
    func formattedString(_ style: DateFormatStyle) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = style.format
        return formatter.string(from: self)
    }
}

enum DateFormatStyle {
    case fullDate      // "2025. 02. 13."
    case monthDay     // "0월 0일 (수)"
    case yearMonth     // "2025년 3월"
    
    var format: String {
        switch self {
        case .fullDate:
            return "yyyy. MM. dd."
        case .monthDay:
            return "M월 d일 (E)"
        case .yearMonth:
            return "yyyy년 M월"
        }
    }
}
