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
    /// 시간 정보를 표시하는 라벨
    private let timeLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightOrange
        $0.textAlignment = .left
    }
    
    /// 운동거리 정보를 표시하는 라벨
    private let distanceLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightPink
        $0.textAlignment = .left
    }
    
    /// 걸음수 정보를 표시하는 라벨
    private let stepsLabel = UILabel().then {
        $0.font = .RLHeadline2
        $0.textColor = .LightBlue
        $0.textAlignment = .left
    }
    
    /// 3개 라벨을 수평으로 배치하는 스택뷰
    private lazy var horizontalStack = UIStackView(arrangedSubviews: [timeLabel, distanceLabel, stepsLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 0
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()      // UI 요소들을 contentView에 추가
        setupLayout()  // SnapKit 레이아웃 제약조건 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    /// contentView의 배경색을 설정하고, 수평 스택뷰를 추가하는 메서드
    private func setupUI() {
        contentView.backgroundColor = .Gray900
        contentView.addSubview(horizontalStack)
        
        // 셀 선택 시 배경색 변화 없도록 설정
        selectionStyle = .none
    }
    
    // MARK: - Setup Layout
    /// 수평 스택뷰와 각 라벨의 제약조건을 SnapKit을 이용해 설정하는 메서드
    private func setupLayout() {
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DynamicSize.scaledSize(8))
        }
        
        // 각 라벨의 너비를 전체 스택뷰 너비의 비율로 고정 (0.334, 0.333, 0.333)
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
    /// 레코드 데이터를 받아서 라벨에 설정하고, 폰트를 외부에서 지정할 수 있도록 한 메서드
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
    
    /// 기본적으로 RLHeadline2 폰트를 적용하여 레코드 데이터를 설정하는 메서드
    func configure(with record: RecordDetail) {
        configure(with: record, font: .RLHeadline2)
    }
}
