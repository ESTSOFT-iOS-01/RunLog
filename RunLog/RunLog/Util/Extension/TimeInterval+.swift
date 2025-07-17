//
//  TimeInterval+.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

extension TimeInterval {
    /// TimeInterval (초)를 "X시간 Y분" 형식의 문자열로 변환
    var hourMinuteString: String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        return "\(hours)시간 \(minutes)분"
    }
}
