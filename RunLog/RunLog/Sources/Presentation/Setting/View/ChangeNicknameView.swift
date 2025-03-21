//
//  ChangeNicknameView.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class ChangeNicknameView: UIView {
    
    // MARK: - Properties
    private let placeHolderString = "최대 10자까지 입력 가능합니다"
    
    lazy var nameField = RLTextField(placeholder: placeHolderString).then {
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
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
    
}
