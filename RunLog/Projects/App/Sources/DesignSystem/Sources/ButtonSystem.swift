//
//  ButtonSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//
import RLUtil

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
        
        self.layer.cornerRadius = DynamicSize.scaledSize(16)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(DynamicSize.scaledSize(63))
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
    public func setHeight(_ height: CGFloat) {
        self.snp.remakeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
}

// MARK: - 이미지가 오른쪽에 들어가 있는 AttributedString Title
extension RLButton {
    /// 버튼의 타이틀 오른쪽에 이미지를 추가
    /// - Parameters:
    ///   - imageName: **버튼에 추가할 이미지 systemName**
    ///   - tintColor: **버튼의 틴트 색상 (기본갑시 `.Gray000`)**
    ///
    /// - Example:
    ///   ```swift
    ///   let button = RLButton()
    ///   button.setRightIcon(systemName: "xmark")
    ///   ```
    public func setRightIcon(
        systemName: String,
        tintColor: UIColor = .Gray000
    ) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName)
        config.imagePadding = DynamicSize.scaledSize(4)
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage =
        UIImage.SymbolConfiguration(
            pointSize: DynamicSize.scaledSize(12),
            weight: .medium
        )
        self.tintColor = tintColor
        self.configuration = config
    }
    
    /// 기존의 Title을 지우고 새로운 AttributedTitle을 Set
    /// - Parameters:
    ///   - title: **적용할 타이틀**
    ///   - state: **적용할 버튼 상태 (기본값: `.normal`)**
    ///
    /// - Example:
    ///   ```swift
    ///   let button = RLButton()
    ///   button.setAttributedString(
    ///     title: .RLAttributedString(
    ///         text: "닫기",
    ///         font: .Label2,
    ///         align: .center
    ///     )
    ///   )
    ///   ```
    public func setAttributedString(
        title: NSAttributedString,
        for state: UIControl.State = .normal
    ) {
        //기존의 title 제거
        self.setTitle(nil, for: .normal)
        self.setAttributedTitle(title, for: state)
    }
}
