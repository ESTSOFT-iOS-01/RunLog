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
    // MARK: - Heading
    public static var RLHeading1: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .semibold)
    }
    public static var RLHeading2: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    public static var RLHeading4: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 36) ?? UIFont.systemFont(ofSize: 36, weight: .semibold)
    }
    // MARK: - Headline
    public static var RLHeadline1: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    public static var RLHeadline2: UIFont {
        return UIFont(name: RLFont.regular.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
    }
    public static var RLHeadline3: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    // MARK: - Title
    public static var RLTitle: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    public static var RLMainTitle: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .semibold)
    }
    public static var RLDetailTitle: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32, weight: .semibold)
    }
    // MARK: - etc
    public static var RLBody1: UIFont {
        return UIFont(name: RLFont.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    public static var RLLabel1: UIFont {
        return UIFont(name: RLFont.bold.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    public static var RLLabel2: UIFont {
        return UIFont(name: RLFont.regular.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    public static var RLButton: UIFont {
        return UIFont(name: RLFont.medium.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    public static var RLSegment1: UIFont {
        return UIFont(name: RLFont.semiBold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    public static var RLSegment2: UIFont {
        return UIFont(name: RLFont.medium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
