//
//  ButtonSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then

open class RLButton: UIButton {
    
    /// 버튼 생성
    public init(
        title: String = "Custom Button",
        titleColor: UIColor = .Gray000
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = .LightGreen
        
        self.titleLabel?.font = .RLTitle
        self.layer.cornerRadius = 16
        
        self.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 버튼 텍스트 설정
    public func configureTitle(title: String, titleColor: UIColor, font: UIFont) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    /// 버튼 배경색 설정
    public func configureBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    /// cornerRadius 설정
    public func configureRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    /// 버튼 높이 설정
    public func setHeight(_ height: CFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}
