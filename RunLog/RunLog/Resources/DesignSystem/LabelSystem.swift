//
//  LabelSystemView.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import UIKit
import SnapKit
import Then

/// 아이콘을 내포하는 레이블
final class RLLabel: UIView {
    // MARK: - 내부 Components
    var icon = UIImageView()
    var label = UILabel()
    
    var attributedText: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.text = nil
            label.attributedText = newValue
        }
    }
    override var tintColor: UIColor! {
        get {
            return label.tintColor
        }
        set {
            self.label.tintColor = newValue
            self.icon.tintColor = newValue
        }
    }
    
    /// 레이블 생성
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
        // UI 요소 추가
        self.addSubviews(icon, label)
        if icon.image == nil {
            label.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
        }else {
            icon.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.top.bottom.equalToSuperview().inset(4)
            }
            label.snp.makeConstraints {
                $0.leading.equalTo(icon.snp.trailing)
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
            $0.top.bottom.equalToSuperview().inset(4)
        }
        label.snp.remakeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
}
