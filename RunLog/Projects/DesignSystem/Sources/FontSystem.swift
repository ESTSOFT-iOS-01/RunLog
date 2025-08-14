//
//  ColorSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//
import RLUtil

import UIKit

public enum RLFont {
    case Logo1
    case Logo2
    case SplashSubTitle
    
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
    public var value: UIFont {
        switch self {
        case .Logo1:
            return .RLLogo1
        case .Logo2:
            return .RLLogo2
        case .SplashSubTitle:
            return .RLSplashSubTitle
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
    public var lineHeightMultiple: CGFloat {
        switch self {
        case .Logo1, .Logo2:
            return 1.10
        case .Label1, .Label2:
            return 1.60
        case .Body1, .Body2:
            return 1.50
        case .Headline1, .Headline2, .Label3:
            return 1.45
        case .Heading2:
            return 1.40
        case .SplashSubTitle, .Heading1, .Heading3, .Heading4,
                .Title, .MainTitle, .DetailTitle, .Button, .ButtonBig:
            return 1.35
        case .Segment1, .Segment2:
            return 1.20
        }
    }
}

extension UIFont {
    // MARK: - Font Style
    public enum RacingSansOne: String, CaseIterable {
        case regular = "RacingSansOne-Regular"
    }
    
    public enum NanumMyeongjo: String, CaseIterable {
        case regular = "NanumMyeongjo-Regular"
    }
    
    // TODO: Pretendard로 네이밍 변경
    public enum Pretendard: String, CaseIterable {
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
    
    /// 다이나믹 폰트 사이즈 설정
    private static func dynamicFont(
        name: String,
        baseSize: CGFloat,
        weight: UIFont.Weight
    ) -> UIFont {
        let dynamicSize = DynamicSize.scaledSize(baseSize)
        return UIFont(name: name, size: dynamicSize) ?? UIFont.systemFont(ofSize: dynamicSize, weight: weight)
    }
    
    // MARK: - Logo & Splash Title
    public static var RLLogo1: UIFont {
        dynamicFont(
            name: RacingSansOne.regular.rawValue, baseSize: 44, weight: .regular
        )
    }
    
    public static var RLLogo2: UIFont {
        dynamicFont(
            name: RacingSansOne.regular.rawValue, baseSize: 28, weight: .regular
        )
    }
    
    public static var RLSplashSubTitle: UIFont {
        dynamicFont(
            name: NanumMyeongjo.regular.rawValue, baseSize: 16, weight: .regular
        )
    }
    
    // MARK: - Heading
    public static var RLHeading1: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 22, weight: .semibold)
    }
    public static var RLHeading2: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 20, weight: .semibold)
    }
    public static var RLHeading4: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 36, weight: .semibold)
    }
    
    // MARK: - Headline
    public static var RLHeadline1: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 18, weight: .semibold)
    }
    public static var RLHeadline2: UIFont {
        dynamicFont(name: Pretendard.regular.rawValue, baseSize: 18, weight: .regular)
    }
    public static var RLHeadline3: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 18, weight: .semibold)
    }
    
    // MARK: - Title
    public static var RLTitle: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 24, weight: .semibold)
    }
    public static var RLMainTitle: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 26, weight: .semibold)
    }
    public static var RLDetailTitle: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 32, weight: .semibold)
    }
    
    // MARK: - etc
    public static var RLBody1: UIFont {
        dynamicFont(name: Pretendard.regular.rawValue, baseSize: 16, weight: .regular)
    }
    public static var RLLabel1: UIFont {
        dynamicFont(name: Pretendard.bold.rawValue, baseSize: 14, weight: .bold)
    }
    public static var RLLabel2: UIFont {
        dynamicFont(name: Pretendard.regular.rawValue, baseSize: 14, weight: .regular)
    }
    public static var RLButton: UIFont {
        dynamicFont(name: Pretendard.medium.rawValue, baseSize: 24, weight: .medium)
    }
    public static var RLSegment1: UIFont {
        dynamicFont(name: Pretendard.semiBold.rawValue, baseSize: 16, weight: .semibold)
    }
    public static var RLSegment2: UIFont {
        dynamicFont(name: Pretendard.medium.rawValue, baseSize: 16, weight: .medium)
    }
    
    
}


extension UIFont {
    public static func registerFonts() {
        let fontEnums: [[any RawRepresentable<String>]] = [
            RacingSansOne.allCases,
            NanumMyeongjo.allCases,
            Pretendard.allCases
        ]
        
        let extensions = ["otf", "ttf"]
        
        for fontGroup in fontEnums {
            for font in fontGroup {
                let fontName = font.rawValue
                
                var found = false
                for ext in extensions {
                    if let url = Bundle.module.url(forResource: fontName, withExtension: ext) {
                        var error: Unmanaged<CFError>?
                        if CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error) == false {
                            let description = error?.takeRetainedValue().localizedDescription ?? "Unknown error"
                            print("Font \(fontName).\(ext) failed to register: \(description)")
                        }
                        found = true
                        break
                    }
                }
                
                if !found {
                    print("Font file \(fontName).otf or .ttf not found.")
                }
            }
        }
    }
}

