//
//  String+.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit

extension String {
    /// 특정 부분의 텍스트 스타일을 변경하는 AttributedString 반환
    func styledText(highlightText: String,
                    baseFont: UIFont = .RLHeadline2,
                    baseColor: UIColor = .Gray000,
                    highlightFont: UIFont = .RLHeadline2,
                    highlightColor: UIColor = .LightGreen) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self, attributes: [
            .font: baseFont,
            .foregroundColor: baseColor
        ])
        
        if let range = self.range(of: highlightText) {
            let nsRange = NSRange(range, in: self)
            attributedString.addAttribute(.foregroundColor, value: highlightColor, range: nsRange)
            attributedString.addAttribute(.font, value: highlightFont, range: nsRange)
        }
        
        return attributedString
    }
}
