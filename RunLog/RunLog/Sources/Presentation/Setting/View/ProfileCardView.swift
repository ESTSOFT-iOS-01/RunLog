//
//  ProfileCardView.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then

/// 마이페이지에서 사용되는 카드 스타일 정보 뷰 (운동 기록, 스트릭 등)
final class ProfileCardView: UIView {
    // MARK: - UI Components 선언
    /// 제목 및 값 라벨을 포함하는 뷰
    private var propertyView = UIView().then {
        $0.backgroundColor = .clear
    }

    /// 카드 타이틀 (예: 운동 기록, 연속 스트릭)
    private lazy var propertyTitle = UILabel().then {
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    /// 카드 오른쪽 아이콘 이미지
    private lazy var iconImg = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .Gray900
    }

    /// 수치 값 라벨
    private lazy var propertyValue = UILabel().then {
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
        layer.cornerRadius = DynamicSize.scaledSize(8)
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
            $0.leading.equalToSuperview().offset(DynamicSize.scaledSize(24))
            $0.top.equalToSuperview().offset(DynamicSize.scaledSize(16))
            $0.trailing.lessThanOrEqualTo(iconImg.snp.leading).offset(-DynamicSize.scaledSize(8))
            $0.bottom.equalToSuperview().inset(DynamicSize.scaledSize(16))
        }
        
        iconImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.height.equalTo(DynamicSize.scaledSize(32.0))
        }
        
    }
    
    // MARK: - Configure
    /// 카드 타입 및 값을 이용해 뷰 내용을 구성합니다.
    /// - Parameters:
    ///   - property: 카드 유형
    ///   - value: 수치 값
    func configure(property: ProfileCardType, value: Int) {
        let valueStr = value.formattedString

        propertyTitle.attributedText = .RLAttributedString(
            text: property.title,
            font: .Label1,
            color: .Gray900
        )

        propertyValue.attributedText = .RLAttributedString(
            text: "\(valueStr)\(property.unit)",
            font: .Headline1,
            color: .Gray900
        )

        iconImg.image = UIImage(systemName: property.iconName)?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
    }
}
