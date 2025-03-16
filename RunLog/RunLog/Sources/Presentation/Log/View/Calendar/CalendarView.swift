//
//  CalendarView.swift
//  RunLog
//
//  Created by 신승재 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class CalendarView: UIView {
    
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
        backgroundColor = .Gray900
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
