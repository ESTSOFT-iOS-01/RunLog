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
    
    private var dayLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "",
            font: .Label2,
            color: .Gray000
        )
        $0.textAlignment = .center
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private var heartBeatImageView = UIImageView().then {
        $0.image = UIImage(named: RLIcon.heartBeat.name)
    }
    
    private lazy var horizontalStackView = UIStackView(
        arrangedSubviews: []
    ).then {
        $0.backgroundColor = .clear
        $0.spacing = -4
        $0.axis = .horizontal
        $0.distribution = .fill
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
        addSubviews(dayLabel, lineView, horizontalStackView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        dayLabel.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(day: Int, heartBeatCount: Int) {
        if day != .zero {
            self.dayLabel.text = "\(day)"
            self.lineView.backgroundColor = .LightPink
            
        } else {
            self.dayLabel.text = ""
            self.lineView.backgroundColor = .clear
        }
    }
}
