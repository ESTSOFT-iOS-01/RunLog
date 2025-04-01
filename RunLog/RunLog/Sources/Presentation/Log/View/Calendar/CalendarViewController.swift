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
    
    // MARK: - Properties
    private let calendarView = CalendarView()
    private let viewModel: LogViewModel
    
    // 화면에 표시되고 있는 달력의 년, 월이 들어간 딕셔너리의 키 인덱스
    private var currentKeyIndex = 0
    // 캘린더에 표시되고 있는 달력 년,월
    private var currentYearMonth: Date = Date()
    // 캘린더에 표시되고 있는 하루하루의 데이터
    private var currentMonthDays: [CalendarDay] = []
    
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
        setupCollectionView()
        bindGesture()
        bindViewModel()
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 랜덤 멘트 설정
        let randomMotivation = Constants.MotivationMessage.random
        calendarView.walkImage.image = UIImage(
            named: randomMotivation.icon.name
        )
        calendarView.bottomLabel.text = randomMotivation.message
    }
    
    private func setupCollectionView() {
        calendarView.collectionView.dataSource = self
        calendarView.collectionView.delegate = self
    }
    
    
    // MARK: - Bind Gesture
    private func bindGesture() {
        calendarView.leftArrowButton.publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // 1. 년/월의 정보가 들어있는 키가 들어있는 배열의 크기를 가져온다.
                let keys = self.viewModel.output.sortedKeys.value
                
                // 2. 현재 인덱스에 + 1
                let newIndex = self.currentKeyIndex + 1
                
                // 3. 바뀐 인덱스가 유효한 범위 이내에 있는지 확인
                guard newIndex >= 0 && newIndex < keys.count else { return }
                
                // 4. currentKeyIndex에 새로운 인덱스 넣어주기
                self.currentKeyIndex = newIndex
                
                // 5. 현재 보고 있는 년월 넣어주기
                self.currentYearMonth = keys[newIndex]
                
                // 6. 현재 보고 있는 년월 기준으로 하루 날짜 데이터 생성
                self.currentMonthDays = generateDaysFor(date: keys[newIndex])
                
                // 7. 캘린더 업데이트
                self.updateCalendar()
                
            }.store(in: &cancellables)
        
        calendarView.rightArrowButton.publisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                // 1. 년/월의 정보가 들어있는 키가 들어있는 배열의 크기를 가져온다.
                let keys = self.viewModel.output.sortedKeys.value
                
                // 2. 현재 인덱스에 - 1
                let newIndex = self.currentKeyIndex - 1
                
                // 3. 바뀐 인덱스가 유효한 범위 이내에 있는지 확인
                guard newIndex >= 0 && newIndex < keys.count else { return }
                
                // 4. currentKeyIndex에 새로운 인덱스 넣어주기
                self.currentKeyIndex = newIndex
                
                // 5. 현재 보고 있는 년월 넣어주기
                self.currentYearMonth = keys[newIndex]
                
                // 6. 현재 보고 있는 년월 기준으로 하루 날짜 데이터 생성
                self.currentMonthDays = generateDaysFor(date: keys[newIndex])
                
                // 7. 캘린더 업데이트
                self.updateCalendar()
            }.store(in: &cancellables)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output.nickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] name in
                self?.calendarView.nicknameLabel.text = "\(name) 님,"
            }.store(in: &cancellables)
        
        viewModel.output.sortedKeys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keys in
                guard let self = self else { return }
                // 1. 년/월 정보가 들어있는 키값들의 첫번째 요소(가장 최근일자) 가져오기, 데이터가 아예 없다면 캘린더 표시를 위해 현재 월
                self.currentYearMonth = viewModel.output.sortedKeys.value.first ?? Date()
                
                // 2. currentMonthDays에 가장 최근일자 데이터 기준으로 해당 월의 하루하루 데이터 생성
                self.currentMonthDays = generateDaysFor(date: self.currentYearMonth)
                
                // 3. 캘린더 업데이트
                self.updateCalendar()
                
            }.store(in: &cancellables)
    }
}

extension CalendarViewController {
    // 캘린더 업데이트 함수
    private func updateCalendar() {
        calendarView.calendarTitleLabel.text = self.currentYearMonth.formattedString(.yearMonthShort)
        updateArrowButtons()
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
    // TODO: 리팩토링~
    private func generateDaysFor(date: Date) -> [CalendarDay] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let firstDayOfMonth = calendar.date(from: components),
              let totalDays = calendar.range(of: .day, in: .month, for: firstDayOfMonth)?.count else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        var calendarDays: [CalendarDay] = []
        
        // 현재 month에 해당하는 log 가져오기
        let dayLogs = viewModel.output.groupedDayLogs.value[date] ?? []
        let unit = viewModel.output.distanceUnit.value
        
        // 비어있는 날짜 채우기
        for _ in 0..<(firstWeekday - 1) {
            calendarDays.append(CalendarDay(day: 0, heartBeatCount: 0))
        }
        
        // 날짜 채우기 + heartBeatCount 계산
        for day in 1...totalDays {
            let matchingLogs = dayLogs.filter {
                calendar.component(.day, from: $0.date) == day
            }
            
            var heartBeatCount = 0
            if let log = matchingLogs.first {
                let distance = log.totalDistance
                if distance == 0 {
                    heartBeatCount = 0
                } else if distance < unit * (1.0 / 3.0) {
                    heartBeatCount = 1
                } else if distance < unit * (2.0 / 3.0) {
                    heartBeatCount = 2
                } else {
                    heartBeatCount = 3
                }
            }
            
            calendarDays.append(CalendarDay(day: day, heartBeatCount: heartBeatCount))
        }
        
        return calendarDays
    }
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        let dayInfo = currentMonthDays[indexPath.row]
        cell.configure(day: dayInfo.day, heartBeatCount: dayInfo.heartBeatCount)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard currentMonthDays[indexPath.row].heartBeatCount > 0 else { return }

        let key = viewModel.output.sortedKeys.value[currentKeyIndex]
        let calendar = Calendar.current

        // 1. key에서 year, month 꺼내기
        let components = calendar.dateComponents([.year, .month], from: key)

        // 2. day 붙이기
        var finalComponents = components
        finalComponents.day = currentMonthDays[indexPath.row].day

        // 3. 최종 Date 만들기
        if let date = calendar.date(from: finalComponents) {
            viewModel.input.send(.cellTapped(date: date))
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let width = collectionView.bounds.width / 7
        let height = collectionView.bounds.height / 6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}
