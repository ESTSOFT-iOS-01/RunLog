//
//  UINavigationController+.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit

extension UIViewController {
    
    /// 네비게이션 바의 스타일 설정
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.Gray000,
            .font: UIFont.RLHeadline1
        ]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
    }
    
    /// 탭 바의 스타일 설정
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#1C1C1C")
        appearance.shadowColor = .clear
        
        self.tabBarController?.tabBar.standardAppearance = appearance
        self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
        self.tabBarController?.tabBar.tintColor = .LightGreen
    }
}
