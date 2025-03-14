//
//  DesignSystem.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import Foundation
import UIKit

// MARK: - 컬러
enum DesignSystemColor {
    // Gray
    case Gray00
    case Gray100
    case Gray200
    case Gray300
    case Gray400
    case Gray500
    case Gray600
    case Gray700
    case Gray800
    case Gray900
    // Green
    case GreenLightActive
    // Blue
    case BlueLightActive
    //Orange
    case OrangeLightActive
    // Pink
    case PinkLightActive
}

extension DesignSystemColor {
    var value: UIColor {
        switch self {
        case .Gray00:
            return UIColor(hex: "#EFEFEF")
        case .Gray100:
            return UIColor(hex: "#B0AEB3")
        case .Gray200:
            return UIColor(hex: "#B0AEB3")
        case .Gray300:
            return UIColor(hex: "#8B888F")
        case .Gray400:
            return UIColor(hex: "#67646C")
        case .Gray500:
            return UIColor(hex: "#454348")
        case .Gray600:
            return UIColor(hex: "#454348")
        case .Gray700:
            return UIColor(hex: "#454348")
        case .Gray800:
            return UIColor(hex: "#252427")
        case .Gray900:
            return UIColor(hex: "#111113")
        case .GreenLightActive:
            return UIColor(hex: "#B1F7B1")
        case .BlueLightActive:
            return UIColor(hex: "#B2E0F4")
        case .OrangeLightActive:
            return UIColor(hex: "#FEE7B6")
        case .PinkLightActive:
            return UIColor(hex: "#FECFFE")
        }
    }
}

// MARK: - 폰트
enum DesignSystemFont {
    case Heading1
    case Heading2
    case Heading3
    case Heading4
    case Headline1
    case Headline2
    case Title
    case MainTitle
    case DetailTitle
    case Body1
    case Body2
    case Label1
    case Label2
    case Label3
    case Button
    case ButtonBig
    case Segment1
    case Segment2
}

extension DesignSystemFont {
    var value: UIFont {
        switch self {
        case .Heading1:
            return UIFont.pretendard(.semiBold, size: 22)
        case .Heading2:
            return UIFont.pretendard(.semiBold, size: 20)
        case .Heading3:
            return UIFont.pretendard(.semiBold, size: 22)
        case .Heading4:
            return UIFont.pretendard(.semiBold, size: 36)
        case .Headline1:
            return UIFont.pretendard(.semiBold, size: 18)
        case .Headline2:
            return UIFont.pretendard(.regular, size: 18)
        case .Title:
            return UIFont.pretendard(.semiBold, size: 24)
        case .MainTitle:
            return UIFont.pretendard(.semiBold, size: 26)
        case .DetailTitle:
            return UIFont.pretendard(.semiBold, size: 32)
        case .Body1:
            return UIFont.pretendard(.regular, size: 16)
        case .Body2:
            return UIFont.pretendard(.semiBold, size: 18)
        case .Label1:
            return UIFont.pretendard(.bold, size: 14)
        case .Label2:
            return UIFont.pretendard(.regular, size: 14)
        case .Label3:
            return UIFont.pretendard(.semiBold, size: 18)
        case .Button:
            return UIFont.pretendard(.medium, size: 24)
        case .ButtonBig:
            return UIFont.pretendard(.semiBold, size: 24)
        case .Segment1:
            return UIFont.pretendard(.semiBold, size: 16)
        case .Segment2:
            return UIFont.pretendard(.medium, size: 16)
        }
    }
    
    var lineHeightMultiple: CGFloat {
        switch self {
        case .Heading1:
            return 1.35
        case .Heading2:
            return 1.40
        case .Heading3:
            return 1.35
        case .Heading4:
            return 1.35
        case .Headline1:
            return 1.45
        case .Headline2:
            return 1.45
        case .Title:
            return 1.35
        case .MainTitle:
            return 1.35
        case .DetailTitle:
            return 1.35
        case .Body1:
            return 1.50
        case .Body2:
            return 1.50
        case .Label1:
            return 1.60
        case .Label2:
            return 1.60
        case .Label3:
            return 1.45
        case .Button:
            return 1.35
        case .ButtonBig:
            return 1.35
        case .Segment1:
            return 1.20
        case .Segment2:
            return 1.20
        }
    }
    
    func attributedString(for text: String, color: UIColor = .black) -> NSAttributedString {
        let font = self.value
        let lineHeight = font.lineHeight * self.lineHeightMultiple
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (lineHeight - font.lineHeight) / 2
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - 아이콘
enum DesignSystemIcon {
    case closeButton
}

extension DesignSystemIcon {
    var name: String {
        switch self {
        case .closeButton:
            return "xmark"
        }
    }
}
