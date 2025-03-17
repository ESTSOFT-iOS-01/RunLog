//
//  TimelineViewController.swift
//  RunLog
//
//  Created by 신승재 on 3/16/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class TimelineViewController: UIViewController {
    
    // MARK: - DI
    private let timelineView = TimelineView()
    private let viewModel: LogViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: LogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGesture()
        setupData()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(timelineView)
        timelineView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        timelineView.tableView.delegate = self
        timelineView.tableView.dataSource = self
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
//        viewModel.output.dayLogs
//            .sink { [weak self] value in
//                // View 업데이트 로직
//            }
//            .store(in: &cancellables)
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.sortedKeys.value.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let key = viewModel.output.sortedKeys.value[section]
        return viewModel.output.groupedDayLogs.value[key]?.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: TimelineViewCell.identifier,
          for: indexPath
        ) as! TimelineViewCell

        let key = viewModel.output.sortedKeys.value[indexPath.section]
        
        if let dayLogs = viewModel.output.groupedDayLogs.value[key] {
            let dayLog = dayLogs[indexPath.row]
            cell.selectionStyle = .none
            cell.configure(dayLog: dayLog)
        }

        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TimelineHeaderView.identifier
        ) as! TimelineHeaderView
        
        header.configure(
            date: viewModel.output.sortedKeys.value[section]
        )
        
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.backgroundColor = .clear
    }
}
