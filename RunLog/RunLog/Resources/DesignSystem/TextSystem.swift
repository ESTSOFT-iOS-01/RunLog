//
//  AttributedSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit

extension NSAttributedString {
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
