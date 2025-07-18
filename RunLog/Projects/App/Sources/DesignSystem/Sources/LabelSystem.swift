//
//  LabelSystemView.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//
import RLUtil

import UIKit
import SnapKit
import Then

/// 아이콘을 내포하는 레이블
final class RLLabel: UIView {
    // MARK: - 내부 Components
    var icon = UIImageView()
    var label = UILabel()
    
    /// Label의 attributedText 설정
    var attributedText: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.text = nil // 기존의 text가 있으면 삭제 후 지정
            label.attributedText = newValue
        }
    }
    
    /// text와 icon의 색상 변경
    override var tintColor: UIColor! {
        get {
            return label.tintColor
        }
        set {
            self.label.tintColor = newValue
            self.icon.tintColor = newValue
        }
    }
    
    /// 아이콘을 내포한 레이블을 생성합니다.
    /// - Parameters:
    ///   - text: 레이블의 텍스트
    ///   - textColor: 텍스트 색상 (기본값: `.Gray000`)
    ///   - icon: 레이블에 들어갈 아이콘 이미지 (기본값: `nil`)
    ///   - align: 레이블 정렬 상태 (기본값: `.left`)
    ///   - font: 레이블의 폰트 (기본값: `.RLLabel2`)
    ///   - tintColor: 레이블의 틴트 색상 (기본값: `.Gray000`)
    public init(
        text: String = "Custom Label",
        textColor: UIColor = .Gray000,
        icon: UIImage? = nil,
        align: NSTextAlignment = .left,
        font: UIFont = .RLLabel2,
        tintColor: UIColor = .Gray000
    ) {
        super.init(frame: .zero)
        self.label.text = text
        self.label.textColor = textColor
        self.icon.image = icon
        self.label.textAlignment = align
        self.label.font = font
        self.label.tintColor = tintColor
        self.icon.tintColor = tintColor
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // subview
        self.addSubview(icon)
        self.addSubview(label)
        
        // autoLayout
        if icon.image == nil {
            label.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        else {
            icon.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.top.bottom.equalToSuperview().inset(DynamicSize.scaledSize(4))
            }
            label.snp.makeConstraints {
                $0.leading.equalTo(icon.snp.trailing).offset(DynamicSize.scaledSize(8))
                $0.top.bottom.trailing.equalToSuperview()
            }
        }
    }
    
    /// 아이콘 이미지 설정
    public func setImage(image: UIImage?) {
        self.icon.image = image
        self.icon.tintColor = .Gray000
        icon.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(DynamicSize.scaledSize(4))
        }
        label.snp.remakeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(DynamicSize.scaledSize(8))
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
