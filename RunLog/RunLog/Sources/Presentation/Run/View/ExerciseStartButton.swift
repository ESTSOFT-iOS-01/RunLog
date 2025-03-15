//
//  ExerciseStartButtonView.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit
import SnapKit
import Then

final class ExerciseStartButton: UIButton {
    
    // MARK: - UI Components 선언
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        self.setAttributedTitle(
            .RLAttributedString(
                text: "운동 시작하기",
                font: .ButtonBig,
                color: .Gray900,
                align: .center
            ),
            for: .normal
        )
        self.layer.cornerRadius = 16
        self.backgroundColor = .LightGreen
        
        
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
