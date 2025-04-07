//
//  DetailLogViewModel.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import MapKit
import Combine

final class DetailLogViewModel {
    
    // MARK: - Properties
    /// 선택된 날짜
    let date: Date

    // MARK: - Input & Output
    enum Input {
        case menuSelected(String)
    }
    
    enum Output {
        case loadedDayLog(DayLog)
        case edit
        case share
        case delete
    }
    
    /// 사용자 입력을 받기 위한 subject
    let input = PassthroughSubject<Input, Never>()
    /// 뷰모델 출력 이벤트를 전달하기 위한 subject (초기값은 nil)
    let output = CurrentValueSubject<Output?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    /// DayLogUseCase 의존성 주입 (주입 도구를 통해 할당)
    @Dependency private var dayLogUseCase: DayLogUseCase
    
    // MARK: - DayLog Subject
    /// 외부에서 가져온 DayLog 데이터를 저장 및 업데이트하기 위한 subject
    let dayLogSubject = CurrentValueSubject<DayLog?, Never>(nil)
    
    /// 외부에서 구독할 수 있는 DayLog publisher (nil 제외)
    var dayLogPublisher: AnyPublisher<DayLog, Never> {
        dayLogSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    /// 전체 경로 좌표 배열을 publisher로 제공 (모든 섹션의 좌표를 합침)
    var allCoordinatesPublisher: AnyPublisher<[CLLocationCoordinate2D], Never> {
        dayLogPublisher
            .map { dayLog in
                dayLog.sections.flatMap { section in
                    section.route.map {
                        CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// 각 섹션별 좌표 배열을 publisher로 제공
    var coordinatesBySectionPublisher: AnyPublisher<[[CLLocationCoordinate2D]], Never> {
        dayLogPublisher
            .map { dayLog in
                dayLog.sections.map { section in
                    section.route.map {
                        CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Init
    init(date: Date) {
        self.date = date
        bind()
        loadTargetDayLog(date: date)
    }
    
    // MARK: - Bind (Input -> Output)
    /// Input 이벤트를 처리하여 적절한 Output 이벤트를 발생시키는 메서드
    private func bind() {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .menuSelected(let title):
                    switch title {
                    case "수정하기":
                        self.output.send(.edit)
                    case "공유하기":
                        self.output.send(.share)
                    case "삭제하기":
                        self.output.send(.delete)
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
    /// 지정된 날짜에 해당하는 DayLog 데이터를 비동기로 불러오고, 섹션을 내림차순(최신순)으로 정렬하여 업데이트
    private func loadTargetDayLog(date: Date) {
        Task {
            guard let dayLog = try await dayLogUseCase.getDayLogByDate(date) else { return }
            
            // 각 Section의 첫 좌표 timestamp를 기준으로 내림차순 정렬
            let sortedSections = dayLog.sections.sorted { lhs, rhs in
                let lhsStartTime = lhs.route.sorted { $0.timestamp < $1.timestamp }
                    .first?.timestamp ?? Date.distantPast
                let rhsStartTime = rhs.route.sorted { $0.timestamp < $1.timestamp }
                    .first?.timestamp ?? Date.distantPast
                return lhsStartTime > rhsStartTime
            }
            
            // 정렬된 섹션을 기반으로 새 DayLog 생성
            var sortedDayLog = dayLog
            sortedDayLog.sections = sortedSections
            
            // 업데이트된 DayLog를 subject와 output으로 전달
            dayLogSubject.send(sortedDayLog)
            output.send(.loadedDayLog(sortedDayLog))
        }
    }
    
    /// 선택된 날짜의 DayLog 데이터를 삭제하는 메서드 (비동기)
    func deleteDayLog() async throws {
        try await dayLogUseCase.deleteDayLogByDate(date)
    }
    
    /// DayLog 데이터를 새로고침하는 메서드
    func refreshDayLog() {
        loadTargetDayLog(date: date)
    }
}
