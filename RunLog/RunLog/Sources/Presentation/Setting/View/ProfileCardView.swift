//
//  ProfileCardView.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then

enum ProfileCardType {
    case logCount
    case streak
}

final class ProfileCardView: UIView {
    // MARK: - UI Components 선언
    var propertyView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var propertyTitle = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    lazy var iconImg = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Gray900
    }
    
    lazy var propertyValue = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .LightGreen80
        layer.cornerRadius = 8
        clipsToBounds = true
        
        propertyView.addSubviews(propertyTitle, propertyValue)
        addSubviews(propertyView, iconImg)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        propertyTitle.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        propertyValue.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.top.equalTo(propertyTitle.snp.bottom)
        }
        
        propertyView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.lessThanOrEqualTo(iconImg.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        iconImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(32.0)
        }
        
    }
    
    // MARK: - Configure
    func configure(property: ProfileCardType, value: Int) {
        let valueStr = value.formattedString
        switch property {
        case .logCount:
            propertyTitle.attributedText = .RLAttributedString(text: "운동 기록", font: .Label1, color: .Gray900)
            iconImg.image = UIImage(systemName: RLIcon.document.name)?
                .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
            propertyValue.attributedText = .RLAttributedString(text: "\(valueStr)건", font: .Headline1, color: .Gray900)
        case .streak:
            propertyTitle.attributedText = .RLAttributedString(text: "연속 스트릭", font: .Label1, color: .Gray900)
            iconImg.image = UIImage(systemName: RLIcon.streak.name)?
                .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
            propertyValue.attributedText = .RLAttributedString(text: "\(valueStr)일", font: .Headline1, color: .Gray900)
        }
    }
}
