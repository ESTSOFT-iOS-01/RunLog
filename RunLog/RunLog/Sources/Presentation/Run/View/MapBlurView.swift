//
//  MapBlurView.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class MapBlurView: UIView {
    
    // MARK: - Focus Area (Blur) UI
    private var blurBackground = UIView().then {
        $0.backgroundColor = .clear
    }
    private var gradientLayer = CAGradientLayer().then {
        $0.type = .radial
    }
    
    // MARK: - Out of Focus Area UI
    private var topBackground = UIView()
    private var bottomBackground = UIView()
    private var leadingBackground = UIView()
    private var trailingBackground = UIView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AutoLayout 적용 후 Gradient 추가
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // 블러 제외 배경 검은색 지정
        [topBackground, bottomBackground, leadingBackground, trailingBackground]
            .forEach { $0.backgroundColor = .black }
        
        // UI 요소 추가
        self.addSubviews(
            blurBackground,
            topBackground,
            bottomBackground,
            leadingBackground,
            trailingBackground
        )
        
        // 블러 효과가 올라가는 뷰
        blurBackground.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(DynamicSize.scaledSize(30))
            $0.width.height.equalTo(DynamicSize.scaledSize(441))
        }
        
        topBackground.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(blurBackground.snp.top)
        }
        
        bottomBackground.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(blurBackground.snp.bottom)
        }
        
        leadingBackground.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(blurBackground.snp.leading)
            $0.top.equalTo(topBackground)
            $0.bottom.equalTo(snp_bottomMargin)
        }
        
        trailingBackground.snp.makeConstraints {
            $0.leading.equalTo(blurBackground.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(topBackground)
            $0.bottom.equalTo(snp_bottomMargin)
        }
    }
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        gradientLayer.removeFromSuperlayer() // 기존 레이어 제거 (중복 방지)
        gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        
        // background2를 전부 덮도록
        gradientLayer.frame = CGRect(
            x: 0, y: 0,
            width: blurBackground.bounds.width,
            height: blurBackground.bounds.height
        )
        
        gradientLayer.position = CGPoint(
            x: blurBackground.bounds.midX,
            y: blurBackground.bounds.midY
        )
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.black.cgColor
        ]
        
        gradientLayer.locations = [0.4, 0.6, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        blurBackground.layer.addSublayer(gradientLayer)
    }
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
