//
//  RecordDetailView.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class RecordDetailView: UIView {
    
    // MARK: - UI Components 선언
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        // 셀 등록
        $0.register(RecordDetailViewCell.self, forCellReuseIdentifier: RecordDetailViewCell.identifier)
        
        // 테이블뷰 기본 설정
        $0.isScrollEnabled = false
        $0.backgroundColor = .Gray900
        $0.separatorStyle = .singleLine
        $0.separatorColor = .Gray500
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 32
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
        addSubview(tableView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
    
   
}
