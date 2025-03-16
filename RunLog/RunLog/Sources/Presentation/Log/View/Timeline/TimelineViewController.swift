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
    private var dayLogs: [DayLog] = []
    
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
        dayLogs = DummyData.dummyDayLogs
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
//        viewModel.output.something
//            .sink { [weak self] value in
//                // View 업데이트 로직
//            }
//            .store(in: &cancellables)
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return dayLogs.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: TimelineViewCell.identifier,
          for: indexPath
        ) as! TimelineViewCell
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.backgroundColor = .clear
    }

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TimelineHeaderView.identifier
        ) as! TimelineHeaderView
        
        return header
    }
}

enum DummyData {
    static let dummyDayLogs: [DayLog] = [
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 5)) ?? Date(),
            locationName: "서울",
            weather: 1,
            temperature: 5,
            trackImage: Data(),
            title: "아침 산책",
            level: 2,
            totalTime: 1800,
            totalDistance: 2.5,
            totalSteps: 3000,
            sections: []
        ),
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 15)) ?? Date(),
            locationName: "부산",
            weather: 2,
            temperature: 10,
            trackImage: Data(),
            title: "점심 러닝",
            level: 3,
            totalTime: 3600,
            totalDistance: 5.2,
            totalSteps: 7000,
            sections: []
        ),
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 25)) ?? Date(),
            locationName: "제주",
            weather: 3,
            temperature: 8,
            trackImage: Data(),
            title: "비 오는 날 산책",
            level: 1,
            totalTime: 1200,
            totalDistance: 1.8,
            totalSteps: 2000,
            sections: []
        ),
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 3)) ?? Date(),
            locationName: "대구",
            weather: 1,
            temperature: 12,
            trackImage: Data(),
            title: "오후 조깅",
            level: 4,
            totalTime: 4500,
            totalDistance: 6.0,
            totalSteps: 9000,
            sections: []
        ),
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 12)) ?? Date(),
            locationName: "광주",
            weather: 4,
            temperature: -1,
            trackImage: Data(),
            title: "눈 오는 날 하이킹",
            level: 5,
            totalTime: 7200,
            totalDistance: 8.0,
            totalSteps: 12000,
            sections: []
        ),
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 20)) ?? Date(),
            locationName: "서울",
            weather: 2,
            temperature: 7,
            trackImage: Data(),
            title: "저녁 산책",
            level: 2,
            totalTime: 2400,
            totalDistance: 3.0,
            totalSteps: 3500,
            sections: []
        )
    ]
}
