//
//  Int+.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import Foundation

extension Int {
    /// 3자리마다 콤마(,)를 추가하여 문자열로 변환
    var formattedString: String {
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = .decimal
      return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func toWeatherDescription() -> String {
            switch self {
            case 1: return "맑음"
            case 2: return "흐림"
            case 3: return "비"
            case 4: return "눈"
            default: return "알 수 없음"
            }
        }
        
        func toLevelDescription() -> String {
            switch self {
            case 1: return "매우 쉬움"
            case 2: return "쉬움"
            case 3: return "보통"
            case 4: return "어려움"
            case 5: return "매우 어려움"
            default: return "알 수 없음"
            }
        }
}
