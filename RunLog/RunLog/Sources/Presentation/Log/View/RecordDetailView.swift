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
    
    var records: [RecordDetail] = []
    
    func setRecords(_ newRecords: [RecordDetail]) {
        print("RecordDetailView - 새로운 레코드 개수: \(newRecords.count)")
        self.records = newRecords
        tableView.reloadData()
    }
    
    // MARK: - UI Components 선언
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        // 셀 등록
        $0.register(RecordDetailViewCell.self, forCellReuseIdentifier: RecordDetailViewCell.identifier)
        
        // 테이블뷰 기본 설정
        $0.backgroundColor = .Gray900
        $0.separatorStyle = .singleLine
        $0.separatorColor = .Gray500
        $0.rowHeight = 32
        $0.dataSource = self
        $0.delegate = self
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
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}


extension RecordDetailView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 헤더행(1) + 실제 데이터 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count + 1
    }
    
    // 셀 생성 로직
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecordDetailViewCell.identifier,
                for: indexPath
            ) as? RecordDetailViewCell else {
                return UITableViewCell()
            }
            cell.configureAsHeader()
            return cell
        } else {
            let record = records[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecordDetailViewCell.identifier,
                for: indexPath
            ) as? RecordDetailViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: record)
            return cell
        }
    }
}
