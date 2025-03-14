//
//  ColorSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit

public enum RLColor {
    case Gray000
    case Gray100
    case Gray200
    case Gray300
    case Gray500
    case Gray700
    case Gray900

    case LightGreen
    case LightBlue
    case LightOrange
    case LightPink
}

extension UIColor {
    public static var Gray000: UIColor {
        return UIColor(hex: "#EFEFEF")
    }
    
    public static var Gray100: UIColor {
        return UIColor(hex: "#B0AEB3")
    }
    
    public static var Gray200: UIColor {
        return UIColor(hex: "#8B888F")
    }
    
    public static var Gray300: UIColor {
        return UIColor(hex: "#67646C")
    }
    
    public static var Gray500: UIColor {
        return UIColor(hex: "#454348")
    }
    
    public static var Gray700: UIColor {
        return UIColor(hex: "#252427")
    }
    
    public static var Gray900: UIColor {
        return UIColor(hex: "#111113")
    }
    
    public static var LightGreen: UIColor {
        return UIColor(hex: "#B1F7B1")
    }
    
    public static var LightBlue: UIColor {
        return UIColor(hex: "#B2E0F4")
    }
    
    public static var LightOrange: UIColor {
        return UIColor(hex: "#FEE7B6")
    }
    
    public static var LightPink: UIColor {
        return UIColor(hex: "#FECFFE")
    }

}
