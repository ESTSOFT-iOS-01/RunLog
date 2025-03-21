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
        $0.textAlignment = .left
    }
    private let stepsLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightBlue
        $0.textAlignment = .left
    }
    
    // 수평 스택뷰로 3개 라벨 배치
    private lazy var horizontalStack = UIStackView(arrangedSubviews: [timeLabel, distanceLabel, stepsLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 0
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
        
        // 라벨별로 width 비율 고정 (예: 0.4 : 0.3 : 0.3)
        timeLabel.snp.makeConstraints { make in
            make.width.equalTo(horizontalStack.snp.width).multipliedBy(0.334)
        }
        distanceLabel.snp.makeConstraints { make in
            make.width.equalTo(horizontalStack.snp.width).multipliedBy(0.333)
        }
        stepsLabel.snp.makeConstraints { make in
            make.width.equalTo(horizontalStack.snp.width).multipliedBy(0.333)
        }
    }
    
    // MARK: - Configure
    func configureAsHeader() {
        print("헤더 셀 구성 호출됨")
        // 뷰 설정
        timeLabel.font = .RLBody1
        timeLabel.textColor = .Gray000
        timeLabel.textAlignment = .left
        timeLabel.text = "시간대"
        
        distanceLabel.font = .RLBody1
        distanceLabel.textColor = .Gray000
        distanceLabel.textAlignment = .left
        distanceLabel.text = "운동거리"
        
        stepsLabel.font = .RLBody1
        stepsLabel.textColor = .Gray000
        stepsLabel.textAlignment = .left
        stepsLabel.text = "걸음수"
    }
    
    /// 폰트를 외부에서 지정할 수 있도록 수정한 configure 메서드
    func configure(with record: RecordDetail, font: UIFont) {
        timeLabel.font = font
        timeLabel.textColor = .LightOrange
        timeLabel.textAlignment = .left
        timeLabel.text = record.timeRange
        
        distanceLabel.font = font
        distanceLabel.textColor = .LightPink
        distanceLabel.textAlignment = .left
        distanceLabel.text = record.distance
        
        stepsLabel.font = font
        stepsLabel.textColor = .LightBlue
        stepsLabel.textAlignment = .left
        stepsLabel.text = record.steps
    }
    
    // 기존 메서드 유지 (디폴트로 headline2 적용)
    func configure(with record: RecordDetail) {
        configure(with: record, font: .RLHeadline2)
    }
}


