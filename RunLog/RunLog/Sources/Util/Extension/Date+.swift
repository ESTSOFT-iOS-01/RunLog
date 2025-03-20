//
//  Date+.swift
//  RunLog
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
    case fullDate       // "2025. 02. 13."
    case monthDay       // "0월 0일 (수)"
    case yearMonth      // "2025년 3월"
    case yearMonthShort // "25년 3월"
    case fullTime       // "12:23:34:456"
    
    var format: String {
        switch self {
        case .fullDate:
            return "yyyy. MM. dd."
        case .monthDay:
            return "M월 d일 (E)"
        case .yearMonth:
            return "yyyy년 M월"
        case .yearMonthShort:
            return "yy년 M월"
        case .fullTime:
            return "HH:mm:ss:SSS"
        }
    }
}
