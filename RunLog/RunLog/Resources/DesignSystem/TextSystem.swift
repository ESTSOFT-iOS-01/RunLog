//
//  AttributedSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit

extension NSAttributedString {
    /// **RLAttributedString 생성**
    ///
    /// 주어진 텍스트와 스타일을 적용한 `NSAttributedString`을 생성합니다.
    ///
    /// - Parameters:
    ///   - text: **적용할 문자열**
    ///   - font: **RLFont 객체 (커스텀 폰트 및 크기 정보 포함)**
    ///   - color: **텍스트 색상 (기본값: `.Gray000`)**
    ///   - align: **텍스트 정렬 방식 (기본값: `.left`)**
    ///
    /// - Returns: 스타일이 적용된 `NSAttributedString` 객체를 반환합니다.
    ///
    /// - Note:
    ///   - `lineHeightMultiple`을 곱하여 줄 간격을 설정합니다.
    ///   - `baselineOffset`을 조정하여 줄 간격에 따른 텍스트 정렬을 최적화합니다.
    ///
    /// - Example:
    ///   ```swift
    ///   let attributedText = NSAttributedString.RLAttributedString(
    ///       text: "런닝 기록",
    ///       font: .RLHeadline1,
    ///       color: .gray,
    ///       align: .center
    ///   )
    ///   ```
    public static func RLAttributedString(text: String, font: RLFont, color: UIColor = .Gray000, align: NSTextAlignment = .left) -> NSAttributedString {
        let lineHeight = font.value.lineHeight * font.lineHeightMultiple
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = align
      
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font.value,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (lineHeight - font.value.lineHeight) / 2
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
