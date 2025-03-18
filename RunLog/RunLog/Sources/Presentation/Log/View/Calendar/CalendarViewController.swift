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
    
    // 화면에 표시되고 있는 달력을 관리하는 변수
    private var currentKeyIndex = 0
    private var currentMonthDays:[Int] = []
    
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
            .sink { [weak self] _ in
                guard let self = self else { return }
                let keys = self.viewModel.output.sortedKeys.value
                let newIndex = self.currentKeyIndex + 1
                
                guard newIndex >= 0 && newIndex < keys.count else { return }
                
                self.updateCalendar(newIndex: newIndex)
                self.updateArrowButtons()
            }.store(in: &cancellables)
        
        calendarView.rightArrowButton.publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                let keys = self.viewModel.output.sortedKeys.value
                let newIndex = self.currentKeyIndex - 1
                
                guard newIndex >= 0 && newIndex < keys.count else { return }
                
                self.updateCalendar(newIndex: newIndex)
                self.updateArrowButtons()
            }.store(in: &cancellables)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output.sortedKeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keys in
                guard let self = self, !keys.isEmpty else { return }
                
                let month = viewModel.output.sortedKeys.value.first ?? Date()
                self.currentMonthDays = generateDaysFor(date: month)
                calendarView.calendarTitleLabel.text = month.formattedString(
                    .yearMonthShort
                )
                self.updateArrowButtons()
                
            }
            .store(in: &cancellables)
        
        viewModel.output.groupedDayLogs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.calendarView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension CalendarViewController {
    // 캘린더 업데이트 함수
    private func updateCalendar(newIndex: Int) {
        let keys = viewModel.output.sortedKeys.value
        currentKeyIndex = newIndex
        currentMonthDays = generateDaysFor(date: keys[newIndex])
        calendarView.calendarTitleLabel.text = keys[newIndex].formattedString(.yearMonthShort)
        calendarView.collectionView.reloadData()
    }

    // 버튼 상태 업데이트 함수
    private func updateArrowButtons() {
        let sortedKeysCount = viewModel.output.sortedKeys.value.count
        let isLeftEnabled = currentKeyIndex + 1 < sortedKeysCount
        let isRightEnabled = currentKeyIndex - 1 >= 0
        
        calendarView.leftArrowButton.isEnabled = isLeftEnabled
        calendarView.leftArrowButton.tintColor = isLeftEnabled ? .Gray000 : .Gray200

        calendarView.rightArrowButton.isEnabled = isRightEnabled
        calendarView.rightArrowButton.tintColor = isRightEnabled ? .Gray000 : .Gray200
    }
    
    // date를 기반으로 그 달의 days를 만들어내는 함수
    private func generateDaysFor(date: Date) -> [Int] {
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
        cell.configure(day: currentMonthDays[indexPath.row], heartBeatCount: 2)
        return cell
    }
}
