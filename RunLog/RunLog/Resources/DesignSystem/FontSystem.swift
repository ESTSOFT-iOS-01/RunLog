//
//  ColorSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit

extension UIFont {
    public enum RLFont : String {
        case pThin = "Pretendard-Thin"
        case pRegular = "Pretendard-Regular"
        case pMedium = "Pretendard-Medium"
        case pLight = "Pretendard-Light"
        case pExtraLight = "Pretendard-ExtraLight"
        case pExtraBold = "Pretendard-ExtraBold"
        case pBold = "Pretendard-Bold"
        case pSemiBold = "Pretendard-SemiBold"
        case pBlack = "Pretendard-Black"
    }
    
    // MARK: - Heading Styles
    public static var LRHeading1: UIFont {
        return UIFont(name: RLFont.pSemiBold.rawValue, size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .semibold)
    }
    
    public static var LRHeading2: UIFont {
        return UIFont(name: RLFont.pBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    public static var LRBody: UIFont {
        return UIFont(name: RLFont.pRegular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
