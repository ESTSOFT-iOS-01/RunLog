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
    /// 테이블뷰: 기록 상세 데이터를 표시하기 위한 테이블뷰
    lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        // 셀 등록
        $0.register(RecordDetailViewCell.self, forCellReuseIdentifier: RecordDetailViewCell.identifier)
        // 헤더 뷰 등록
        $0.register(RecordDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: RecordDetailHeaderView.identifier)
        
        // 테이블뷰 기본 설정
        $0.isScrollEnabled = false
        $0.backgroundColor = .Gray900
        $0.separatorStyle = .singleLine
        $0.separatorColor = .Gray500
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = DynamicSize.scaledSize(32)
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    
    /// KVO 관찰자: 테이블뷰 contentSize 변경을 관찰하기 위한 변수
    private var contentSizeObservation: NSKeyValueObservation?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()      // UI 요소 추가
        setupLayout()  // 레이아웃 제약조건 설정
        configure()    // 추가 설정 (KVO 관찰 시작)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    /// 배경색을 설정하고 테이블뷰를 서브뷰로 추가
    private func setupUI() {
        backgroundColor = .Gray900
        addSubview(tableView)
    }
    
    // MARK: - Setup Layout
    /// SnapKit을 사용해 테이블뷰의 레이아웃 제약조건을 설정
    private func setupLayout() {
        // 테이블뷰의 가장자리와 고정된 초기 높이 설정 (이후 contentSize 변경에 따라 업데이트됨)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(DynamicSize.scaledSize(50)) // 초기 높이
        }
        // 셀 구분선 인셋 설정
        tableView.separatorInset = UIEdgeInsets(top: 0, left: DynamicSize.scaledSize(8), bottom: 0, right: DynamicSize.scaledSize(8))
    }
    
    // MARK: - Configure
    /// 테이블뷰의 contentSize를 관찰하여 높이 제약조건을 업데이트하는 설정 수행
    private func configure() {
        observeTableViewContentSize()
    }
    
    // MARK: - KVO: contentSize 관찰 및 높이 업데이트 + 디버그 출력
    /// 테이블뷰의 contentSize 변화를 감지하여 제약조건을 업데이트하고 레이아웃을 새로 고침
    private func observeTableViewContentSize() {
        contentSizeObservation = tableView.observe(\.contentSize, options: [.new, .old]) { [weak self] tableView, change in
            guard let self = self, let newSize = change.newValue else { return }
            // SnapKit을 통해 높이 제약조건 업데이트
            self.tableView.snp.updateConstraints { make in
                make.height.equalTo(newSize.height)
            }
            // 레이아웃 강제 업데이트
            self.setNeedsLayout()
            self.layoutIfNeeded()
            // 디버그 출력을 원할 경우 주석 해제하여 사용 가능
            // print("디버그: tableView의 contentSize 변경됨: \(change.oldValue ?? .zero) -> \(newSize), 시각: \(Date())")
            // print("디버그: 업데이트 후 tableView의 frame.height: \(self.tableView.frame.height), 시각: \(Date())")
        }
    }
    
    deinit {
        contentSizeObservation?.invalidate()
    }
}
