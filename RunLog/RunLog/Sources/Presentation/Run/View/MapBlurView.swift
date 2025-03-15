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
    
    // MARK: - UI Components 선언
    var background1 = UIView().then {
        $0.backgroundColor = .black
    }
    var background2 = UIView().then {
        $0.backgroundColor = .clear
    }
    var background3 = UIView().then {
        $0.backgroundColor = .black
    }
    var gradientLayer = CAGradientLayer().then {
        $0.type = .radial
    }
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
        // UI 요소 추가
        [background1, background2, background3].forEach { self.addSubview($0) }
        // 블러 효과가 올라가는 뷰
        background2.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.width)
        }
        // 블러 효과 위쪽 뷰
        background1.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(background2.snp.top)
        }
        // 블러 효과 아래쪽 뷰
        background3.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(background2.snp.bottom)
        }
    }
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        gradientLayer.removeFromSuperlayer() // 기존 레이어 제거 (중복 방지)
        gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.frame = background2.bounds
        gradientLayer.position = CGPoint(x: background2.bounds.midX, y: background2.bounds.midY)
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.black.cgColor
        ]
        
        gradientLayer.locations = [0.4, 0.6, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.95, y: 0.95)
        
        background2.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
