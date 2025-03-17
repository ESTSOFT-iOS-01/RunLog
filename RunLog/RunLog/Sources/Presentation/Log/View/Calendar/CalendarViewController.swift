//
//  CalendarViewController.swift
//  RunLog
//
//  Created by 신승재 on 3/16/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class CalendarViewController: UIViewController {
    
    // MARK: - DI
    private let calendarView = CalendarView()
    private let viewModel: LogViewModel
    private var cancellables = Set<AnyCancellable>()
    private var days: [String] = []
    
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
        // UI 요소 추가
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        calendarView.collectionView.dataSource = self
        calendarView.collectionView.delegate = self
    }
    
    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        self.days = generateDaysForMonth(year: 2025, month: 3)
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

extension CalendarViewController {
    func generateDaysForMonth(year: Int, month: Int) -> [String] {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        
        guard let firstDayOfMonth = calendar.date(
            from: components
        ) else { return [] }
        
        guard let totalDays = calendar.range(
            of: .day,
            in: .month,
            for: firstDayOfMonth
        )?.count else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var daysArray: [String] = []
        let emptyDays = firstWeekday - 1
        daysArray.append(contentsOf: Array(repeating: "", count: emptyDays))
        
        daysArray.append(contentsOf: (1...totalDays).map { "\($0)" })
        
        return daysArray
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return days.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarViewCell.identifier,
            for: indexPath
        ) as! CalendarViewCell
        cell.dayLabel.text = days[indexPath.row]
        return cell
    }
}
