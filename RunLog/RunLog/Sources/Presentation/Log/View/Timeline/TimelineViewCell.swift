//
//  TimelineViewCell.swift
//  RunLog
//
//  Created by 신승재 on 3/16/25.
//

import UIKit

class TimelineViewCell: UITableViewCell {
    
    static let identifier = "TimelineCell"
    
    // MARK: - UI Component
    private let cellContainer = UIView().then {
        $0.backgroundColor = .Gray700
        $0.layer.cornerRadius = 8
    }
    
    private lazy var distanceLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "25km",
            font: .Heading4,
            color: .LightPink
        )
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "하트런",
            font: .Heading1,
            color: .Gray000
        )
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "2025. 02. 03.",
            font: .Label2,
            color: .Gray200
        )
    }
    
    private lazy var trackImageView = UIImageView().then {
        // TODO: ImageView로 바꾸기
        $0.image = UIImage()
        $0.backgroundColor = .Gray900
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }


    // MARK: - Setup UI
    private func setupUI() {
        cellContainer.addSubviews(distanceLabel, titleLabel, dateLabel, trackImageView)
        self.addSubviews(cellContainer)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        cellContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-18)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.height.equalTo(49)
            $0.top.leading.equalToSuperview().offset(24)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(26)
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(distanceLabel.snp.bottom)
        }
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        trackImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Configure
    func configure(dayLog: DayLog) {
        self.distanceLabel.text = "\(dayLog.totalDistance)km"
        self.titleLabel.text = "\(dayLog.title)"
        self.dateLabel.text = "\(dayLog.date.formattedString(.fullDate))"
    }
}


class TimelineHeaderView: UITableViewHeaderFooterView {

    static let identifier = "TimelineHeader"
    
    // MARK: - UI Component
    private let headerLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "2025년 3월",
            font: .Title,
            color: .Gray000
        )
    }
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(headerLabel)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        headerLabel.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
