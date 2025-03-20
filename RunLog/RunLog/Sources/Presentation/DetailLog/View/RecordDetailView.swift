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
    // KVO 관찰자 (contentSize 변경)
    private var contentSizeObservation: NSKeyValueObservation?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        configure()
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
        // 초기 제약조건은 임의 높이 (나중에 contentSize에 따라 업데이트됨
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(300) // 초기 높이 (나중에 KVO로 업데이트됨)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
        observeTableViewContentSize()
    }
    
    // MARK: - KVO: contentSize 관찰 및 높이 업데이트 + 디버그 출력
    private func observeTableViewContentSize() {
        contentSizeObservation = tableView.observe(\.contentSize, options: [.new, .old]) { [weak self] tableView, change in
            guard let self = self, let newSize = change.newValue else { return }
            print("디버그: tableView의 contentSize가 \(change.oldValue ?? .zero)에서 \(newSize)로 변경됨, 시각: \(Date())")
            
            // SnapKit을 통해 높이 제약조건 업데이트
            self.tableView.snp.updateConstraints { make in
                make.height.equalTo(newSize.height)
            }
            
            // 레이아웃 업데이트 강제 실행
            self.setNeedsLayout()
            self.layoutIfNeeded()
            
            // 업데이트 후 실제 테이블뷰의 높이 출력
            print("디버그: 업데이트 후 tableView의 frame.height: \(self.tableView.frame.height), 시각: \(Date())")
        }
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
    
}
