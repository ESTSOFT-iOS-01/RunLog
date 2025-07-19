//
//  UINavigationController+.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import Combine

extension UINavigationController {
    
    /// 네비게이션 바의 스타일 설정
    public func setupAppearance(
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        font: UIFont,
        tintColor: UIColor
    ) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: foregroundColor,
            .font: font
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = tintColor
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    public func setupTitle(label: UILabel) {
        topViewController?.navigationItem.titleView = label
    }
    
    
    public func setupRightButton(_ button: UIButton) {
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
}
