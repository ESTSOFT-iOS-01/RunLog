//
//  Date+.swift
//  RunLog
//
import Foundation

extension Date {
    
    // 저장하기 위해 연 월만 남기기
    var toYearMonthDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let components = calendar.dateComponents(
            [.year, .month, .day],
            from: self
        )
        return calendar.date(from: components)!
    }
    
    func formattedString(_ style: DateFormatStyle) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
        formatter.dateFormat = style.format
        return formatter.string(from: self)
    }
}

enum DateFormatStyle {
    case fullDate      // "2025. 02. 13."
    case monthDay     // "0월 0일 (수)"
    case yearMonth     // "2025년 3월"
    case yearMonthShort     // "25년 3월"
    case detailedFull  // "2025년 3월 3일 수요일"
    case weekDay      // "월요일"
    
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
        case .detailedFull:
            return "yyyy년 M월 d일 E요일"
        case .weekDay:
            return "E요일"
        }
    }
}
