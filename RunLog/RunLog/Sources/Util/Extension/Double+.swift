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
}
