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
    
    // 소숫점 뒤에 0을 없애주는 애들
    var formattedString: String {
        let formattedString = String(self)
        if let dotIndex = formattedString.firstIndex(of: ".") {
            let afterDot = formattedString[dotIndex...]
            // 소수점 뒤가 0으로만 이루어져 있으면 소수점 제거
            if afterDot.trimmingCharacters(in: CharacterSet(charactersIn: "0")) == "." {
                return String(formattedString.prefix(upTo: dotIndex))
            }
        }
        return String(format: "%.12f", self).replacingOccurrences(of: "\\.?0*$", with: "", options: .regularExpression)
    }
    
    /// 각도를 라디안으로 변환
    var deg2rad: Double { self * .pi / 180 }
    
    /// 라디안을 각도로 변환
    var rad2deg: Double { self * 180 / .pi }
}
