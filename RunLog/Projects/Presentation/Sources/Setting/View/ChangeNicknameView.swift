//
//  ChangeNicknameView.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//
import RLDesignSystem
import RLUtil

import UIKit
import SnapKit
import Then

/// 닉네임 변경 화면의 UI 구성 뷰
final class ChangeNicknameView: UIView {
    
    // MARK: - Properties
    private let nicknamePlaceholder = "최대 10자까지 입력 가능합니다"
    
    /// 닉네임 입력 필드
    lazy var nameField = RLTextField(placeholder: nicknamePlaceholder).then {
        $0.keyboardType = .default
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
        backgroundColor = .Gray900
        addSubview(nameField)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        nameField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(24))
        }
    }
}
