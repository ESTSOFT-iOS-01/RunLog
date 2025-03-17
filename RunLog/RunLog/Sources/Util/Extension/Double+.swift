//
//  Double+.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import Foundation

extension Double {
    /// 소수점 자리수를 지정하여 문자열로 변환
    func toString(withDecimal decimal: Int = 2) -> String {
        return String(format: "%.\(decimal)f", self)
    }
    var asTimeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d : %02d", minutes, seconds)
    }
}
