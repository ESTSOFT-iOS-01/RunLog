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
    
    // 사용자가 보고 있는 달, 일
    private var currentMonth = Date()
    private var currentMonthDays: [Int] = []
    
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
    
    // MARK: - Bind Gesture
    private func bindGesture() {
        calendarView.leftArrowButton.publisher
            .sink {
                print("leftArrowButtonTapped")
            }.store(in: &cancellables)
        
        calendarView.rightArrowButton.publisher
            .sink {
                print("rightArrowButtonTapped")
            }.store(in: &cancellables)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        self.currentMonthDays = generateDaysFor(date: Date())
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        
    }
}

extension CalendarViewController {
    func generateDaysFor(date: Date) -> [Int] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let firstDayOfMonth = calendar.date(
            from: components
        ) else { return [] }
        
        guard let totalDays = calendar.range(
            of: .day,
            in: .month,
            for: firstDayOfMonth
        )?.count else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        var daysArray: [Int] = []
        let emptyDays = firstWeekday - 1
        daysArray.append(contentsOf: Array(repeating: .zero, count: emptyDays))
        
        daysArray.append(contentsOf: (1...totalDays))
        
        return daysArray
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return currentMonthDays.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarViewCell.identifier,
            for: indexPath
        ) as! CalendarViewCell
        cell.configure(day: currentMonthDays[indexPath.row])
        return cell
    }
}
