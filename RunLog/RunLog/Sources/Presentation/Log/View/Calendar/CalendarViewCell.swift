//
//  CalendarViewCell.swift
//  RunLog
//
//  Created by 신승재 on 3/16/25.
//

import UIKit
import SnapKit
import Then

class CalendarViewCell: UICollectionViewCell {
    
    static let identifier = "DayCell"
    
    var dayLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "1",
            font: .Label2,
            color: .Gray000
        )
        $0.textAlignment = .center
    }
    
    // MARK: - init
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
        addSubviews(dayLabel)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        dayLabel.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
