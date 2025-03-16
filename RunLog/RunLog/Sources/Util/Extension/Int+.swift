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
}
