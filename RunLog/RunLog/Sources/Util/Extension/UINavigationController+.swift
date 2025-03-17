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
    func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.Gray000,
            .font: UIFont.RLHeadline1
        ]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .LightGreen
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    /// 오른쪽 버튼 추가
    func addRightButton(
        title: String? = nil,
        icon: String? = nil,
        target: Any?,
        action: Selector
    ) {
        let rightButton = UIButton(type: .system)
        
        if let title = title {
            rightButton.setTitle(title, for: .normal)
            rightButton.setTitleColor(.label, for: .normal)
            rightButton.titleLabel?.attributedText = .RLAttributedString(text: title, font: .Label1, color: .LightGreen, align: .center)
        } else if let icon = icon {
            rightButton.setImage(UIImage(systemName: icon), for: .normal)
            rightButton.tintColor = .LightGreen
        }
        
        rightButton.addTarget(target, action: action, for: .touchUpInside)
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: rightButton
        )
    }
    
    func addRightButton(
        title: String? = nil,
        icon: String? = nil
    ) -> AnyPublisher<Void, Never> {
        let rightButton = UIButton(type: .system)
        
        if let title = title {
            let attributedTitle = NSAttributedString.RLAttributedString(
                text: title,
                font: .Label1,
                color: .LightGreen,
                align: .center
            )
            
            rightButton.setAttributedTitle(attributedTitle, for: .normal)
        } else if let icon = icon {
            rightButton.setImage(UIImage(systemName: icon), for: .normal)
            rightButton.tintColor = .LightGreen
        }
        
        let publisher = rightButton.publisher
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: rightButton
        )
        
        return publisher
    }
}
