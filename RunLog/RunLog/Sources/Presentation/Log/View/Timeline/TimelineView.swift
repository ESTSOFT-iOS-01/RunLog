//
//  TimelineView.swift
//  RunLog
//
//  Created by 신승재 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class TimelineView: UIView {
    
    // MARK: - UI Components 선언
    lazy var tableView = UITableView(
        frame: .zero, style: .grouped
    ).then {
        $0.register(
            TimelineHeaderView.self,
            forHeaderFooterViewReuseIdentifier: TimelineHeaderView.identifier
        )
        
        $0.register(
            TimelineViewCell.self,
            forCellReuseIdentifier: TimelineViewCell.identifier
        )
        
        let cellHeight = 148.0
        let spacing = 18.0
        
        $0.rowHeight = cellHeight + spacing
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .Gray900
        $0.separatorStyle = .none

    }
    
    // MARK: - Init
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
        // UI 요소 추가
        backgroundColor = .Gray900
        addSubviews(tableView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        tableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
