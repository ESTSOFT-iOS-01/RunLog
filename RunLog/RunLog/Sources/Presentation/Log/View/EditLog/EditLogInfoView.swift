//
//  EditLogInfoView.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import UIKit
import SnapKit
import Then

final class EditLogInfoView: UIView {
    
    // MARK: - Properties
    private let placeHolderString = "기록 이름을 필수로 지정해 주세요"
    
    private lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.attributedText = .RLAttributedString(text: "제목", font: .Heading2)
    }
    
    public lazy var nameField = RLTextField(placeholder: placeHolderString).then {
        $0.keyboardType = .default
    }
    
    private lazy var levelLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.attributedText = .RLAttributedString(text: "운동 난이도", font: .Heading2)
    }
    
    public lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .never
        $0.isScrollEnabled = false
        $0.bounces = false
        $0.register(RadioButtonCell.self, forCellReuseIdentifier: RadioButtonCell.identifier)
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
        addSubviews(titleLabel, nameField, levelLabel, tableView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.trailing.equalToSuperview()
        }
        
        nameField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        levelLabel.snp.makeConstraints {
            $0.top.equalTo(nameField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(levelLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}


