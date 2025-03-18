//
//  Date+.swift
//  RunLog
//
//  Created by 심근웅 on 3/18/25.
//

import Foundation
extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS" // 24시간제, 밀리초 포함
        formatter.locale = Locale(identifier: "ko_KR") // 한국 시간 기준
        formatter.timeZone = TimeZone.current // 현재 타임존 적용
        
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
}
