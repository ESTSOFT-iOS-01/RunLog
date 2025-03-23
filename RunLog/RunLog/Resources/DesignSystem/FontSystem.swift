//
//  ColorSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//
import UIKit

public enum RLFont {
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

extension RLFont {
    var value: UIFont {
        switch self {
        case .Heading1, .Heading3:
            return .RLHeading1
        case .Heading2:
            return .RLHeading2
        case .Heading4:
            return .RLHeading4
        case .Headline1, .Body2, .Label3:
            return .RLHeadline1
        case .Headline2:
            return .RLHeadline2
        case .Title, .ButtonBig:
            return .RLTitle
        case .MainTitle:
            return .RLMainTitle
        case .DetailTitle:
            return .RLDetailTitle
        case .Body1:
            return .RLBody1
        case .Label1:
            return .RLLabel1
        case .Label2:
            return .RLLabel2
        case .Button:
            return .RLButton
        case .Segment1:
            return .RLSegment1
        case .Segment2:
            return .RLSegment2
        }
    }
    var lineHeightMultiple: CGFloat {
        switch self {
        case .Label1, .Label2:
            return 1.60
        case .Body1, .Body2:
            return 1.50
        case .Headline1, .Headline2, .Label3:
            return 1.45
        case .Heading2:
            return 1.40
        case .Heading1, .Heading3, .Heading4, .Title, .MainTitle, .DetailTitle, .Button, .ButtonBig:
            return 1.35
        case .Segment1, .Segment2:
            return 1.20
        }
    }
}

extension UIFont {
    // MARK: - Font Style
    public enum RLFont : String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }
    
    // 다이나믹 폰트 사이즈 설정
    private static func dynamicFont(name: String, baseSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let dynamicSize = baseSize * (ScreenSizeManager.shared.screenWidth / 440)
        return UIFont(name: name, size: dynamicSize) ?? UIFont.systemFont(ofSize: dynamicSize, weight: weight)
    }
    // MARK: - Heading
    public static var RLHeading1: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 22, weight: .semibold)
    }
    public static var RLHeading2: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 20, weight: .semibold)
    }
    public static var RLHeading4: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 36, weight: .semibold)
    }
    
    // MARK: - Headline
    public static var RLHeadline1: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 18, weight: .semibold)
    }
    public static var RLHeadline2: UIFont {
        dynamicFont(name: RLFont.regular.rawValue, baseSize: 18, weight: .regular)
    }
    public static var RLHeadline3: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 18, weight: .semibold)
    }
    
    // MARK: - Title
    public static var RLTitle: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 24, weight: .semibold)
    }
    public static var RLMainTitle: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 26, weight: .semibold)
    }
    public static var RLDetailTitle: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 32, weight: .semibold)
    }
    
    // MARK: - etc
    public static var RLBody1: UIFont {
        dynamicFont(name: RLFont.regular.rawValue, baseSize: 16, weight: .regular)
    }
    public static var RLLabel1: UIFont {
        dynamicFont(name: RLFont.bold.rawValue, baseSize: 14, weight: .bold)
    }
    public static var RLLabel2: UIFont {
        dynamicFont(name: RLFont.regular.rawValue, baseSize: 14, weight: .regular)
    }
    public static var RLButton: UIFont {
        dynamicFont(name: RLFont.medium.rawValue, baseSize: 24, weight: .medium)
    }
    public static var RLSegment1: UIFont {
        dynamicFont(name: RLFont.semiBold.rawValue, baseSize: 16, weight: .semibold)
    }
    public static var RLSegment2: UIFont {
        dynamicFont(name: RLFont.medium.rawValue, baseSize: 16, weight: .medium)
    }
}
