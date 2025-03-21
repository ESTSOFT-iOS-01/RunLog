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
        bindGesture()
        bindViewModel()
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

    // MARK: - bindGesture
    private func bindGesture() {
        // 제스처 추가
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output.groupedDayLogs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.timelineView.tableView.reloadData()
            }
            .store(in: &cancellables)
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
            cell.configure(
                totalDistance: dayLog.totalDistance,
                title: dayLog.title,
                date: dayLog.date
            )
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = viewModel.output.sortedKeys.value[indexPath.section]
        if let dayLogs = viewModel.output.groupedDayLogs.value[key] {
            let dayLog = dayLogs[indexPath.row]
            viewModel.send(.cellTapped(date: dayLog.date))
        }
        
    }
}
