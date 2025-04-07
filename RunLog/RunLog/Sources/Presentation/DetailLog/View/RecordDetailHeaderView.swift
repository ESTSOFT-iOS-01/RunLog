//
//  RecordDetailHeaderView.swift
//  RunLog
//
//  Created by 도민준 on 4/7/25.
//

import UIKit
import SnapKit
import Then

final class RecordDetailHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "RecordDetailHeaderView"
    
    // MARK: - UI Components 선언
    /// 시간대를 표시하는 라벨 (예: "시간대")
    private let timeLabel = UILabel().then {
        $0.font = .RLBody1
        $0.textColor = .Gray000
        $0.textAlignment = .left
        $0.text = "시간대"
    }
    
    /// 운동거리를 표시하는 라벨 (예: "운동거리")
    private let distanceLabel = UILabel().then {
        $0.font = .RLBody1
        $0.textColor = .Gray000
        $0.textAlignment = .left
        $0.text = "운동거리"
    }
    
    /// 걸음수를 표시하는 라벨 (예: "걸음수")
    private let stepsLabel = UILabel().then {
        $0.font = .RLBody1
        $0.textColor = .Gray000
        $0.textAlignment = .left
        $0.text = "걸음수"
    }
    
    /// 3개의 라벨을 수평으로 배치하는 스택뷰 (각 라벨의 크기와 간격을 균등하게 배분)
    private lazy var horizontalStack = UIStackView(arrangedSubviews: [timeLabel, distanceLabel, stepsLabel]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = DynamicSize.scaledSize(8)
    }
    
    // MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()     // UI 요소들을 뷰 계층 구조에 추가
        setupLayout() // SnapKit을 이용한 레이아웃 제약 조건 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    /// contentView의 배경색을 설정하고 수평 스택뷰를 추가하는 메서드
    private func setupUI() {
        contentView.backgroundColor = .Gray900
        contentView.addSubview(horizontalStack)
    }
    
    // MARK: - Setup Layout
    /// horizontalStack의 위치와 여백을 SnapKit을 이용해 설정하는 메서드
    private func setupLayout() {
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(DynamicSize.scaledSize(8))
        }
    }
}
