//
//  SettingMenuCell.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//
import RLDesignSystem
import RLUtil

import UIKit
import SnapKit
import Then

/// 마이페이지 설정 메뉴 셀
final class SettingMenuCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "SettingMenuCell"
    
    // MARK: - UI Components
    /// 메뉴 타이틀 라벨
    private let titleLabel = UILabel()

    /// 우측 이동 아이콘
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: RLIcon.rightChevron.name)?
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
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .Gray900
        selectionStyle = .none
        
        contentView.addSubviews(titleLabel, arrowImageView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(DynamicSize.scaledSize(4))
            $0.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(DynamicSize.scaledSize(4))
            $0.centerY.equalToSuperview()
            $0.height.equalTo(DynamicSize.scaledSize(16))
        }
    }
    
    // MARK: - Configure
    /// 셀 타이틀 텍스트 설정
    /// - Parameter title: 메뉴 이름
    func configure(title: String) {
        titleLabel.attributedText = .RLAttributedString(text: title, font: .Body2)
    }

}
