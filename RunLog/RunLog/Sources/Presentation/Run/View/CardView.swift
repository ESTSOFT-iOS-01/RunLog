//
//  CardView.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class CardView: UIView {
    // MARK: - UI Components 선언
    var timeLabel = CardElementView(type: .time)
    var distanceLabel = CardElementView(type: .distance)
    var stepsLabel = CardElementView(type: .steps)
    var finishButton = RLButton(title: "종료", titleColor: .Gray900).then {
        $0.configureBackgroundColor(.Gray100)
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        self.addSubviews(timeLabel, distanceLabel, stepsLabel, finishButton)
        
        finishButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.bottom.equalToSuperview().inset(31)
        }
        timeLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(36)
            $0.height.equalTo(79)
        }
        distanceLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel)
            $0.trailing.equalTo(timeLabel.snp.centerX)
            $0.top.equalTo(timeLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(finishButton.snp.top).offset(-20)
        }
        stepsLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.centerX)
            $0.trailing.equalTo(timeLabel)
            $0.top.equalTo(timeLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(finishButton.snp.top).offset(-20)
        }
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        self.layer.cornerRadius = 32
        self.backgroundColor = .Gray700
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
        timeLabel.setConfigure(text: "00 : 00")
        distanceLabel.setConfigure(text: "0.0km")
        stepsLabel.setConfigure(text: "0")
    }
}
