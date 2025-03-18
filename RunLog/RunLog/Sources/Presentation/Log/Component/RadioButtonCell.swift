//
//  RadioButtonCell.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import UIKit
import SnapKit
import Then

final class RadioButtonCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "RadioButtonCell"
    
    // MARK: - UI Components
    lazy var titleLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(text: "난이도", font: .Headline2)
    }
    
    private lazy var stateImageView = UIImageView().then {
        $0.image = UIImage(systemName: RLIcon.unslectedCircle.name)?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        $0.tintColor = .Gray500
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
        contentView.addSubviews(titleLabel, stateImageView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        stateImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(20)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(stateImageView.snp.trailing).offset(24)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(title: String) {
        titleLabel.attributedText = .RLAttributedString(text: title, font: .Headline2)
    }
    
    func changeState() {
        
    }

}
