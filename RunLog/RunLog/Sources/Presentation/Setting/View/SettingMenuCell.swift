//
//  SettingMenuCell.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import SnapKit
import Then

class SettingMenuCell: UITableViewCell {
    // MARK: - UI Components
    lazy var titleLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(text: "메뉴", font: .Body2)
    }
    
    private lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 16, weight: .regular))
        $0.tintColor = .Gray300
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubviews(titleLabel, arrowImageView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(16)
        }
    }
    
    // MARK: - Configure
    func configure(title: String) {
        titleLabel.text = title
    }

}
