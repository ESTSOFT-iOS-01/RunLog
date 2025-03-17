//
//  RecordDetailViewCell.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class RecordDetailViewCell: UITableViewCell {
    
    static let identifier = "RecordDetailCell"
    
    // MARK: - UI Components 선언
    private let timeLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightOrange
        $0.textAlignment = .left
    }
    private let distanceLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightPink
        $0.textAlignment = .center
    }
    private let stepsLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightBlue
        $0.textAlignment = .right
    }
    
    // 수평 스택뷰로 3개 라벨 배치
    private lazy var horizontalStack = UIStackView(arrangedSubviews: [timeLabel, distanceLabel, stepsLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 8
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
        // UI 요소 추가
        contentView.backgroundColor = .Gray900
        contentView.addSubview(horizontalStack)
        
        // 선택 스타일 제거
        selectionStyle = .none
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Configure
    func configureAsHeader() {
        // 뷰 설정
        timeLabel.font = .RLBody1
        timeLabel.textColor = .Gray000
        timeLabel.textAlignment = .left
        timeLabel.text = "시간대"
        
        distanceLabel.font = .RLBody1
        distanceLabel.textColor = .Gray000
        distanceLabel.textAlignment = .center
        distanceLabel.text = "운동거리"
        
        stepsLabel.font = .RLBody1
        stepsLabel.textColor = .Gray000
        stepsLabel.textAlignment = .right
        stepsLabel.text = "걸음수"
    }
    
    func configure(with record: RecordDetail) {
        timeLabel.font = .RLHeadline2
        timeLabel.textColor = .LightOrange
        timeLabel.textAlignment = .left
        timeLabel.text = record.timeRange
        
        distanceLabel.font = .RLHeadline2
        distanceLabel.textColor = .LightPink
        distanceLabel.textAlignment = .center
        distanceLabel.text = record.distance
        
        stepsLabel.font = .RLHeadline2
        stepsLabel.textColor = .LightBlue
        stepsLabel.textAlignment = .right
        stepsLabel.text = record.steps
    }
}


