//
//  DetailLogViewModel.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//
import RLDomain
import RLInject

import UIKit
import MapKit
import Combine

final class DetailLogViewModel {
    
    // MARK: - Properties
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
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    
    // MARK: - DayLog Subject
    // 외부에서 가져온 DayLog 데이터 저장 및 업데이트를 위해 subject 사용
    let dayLogSubject = CurrentValueSubject<DayLog?, Never>(nil)
    
    // 외부에서 DayLog를 구독할 수 있는 publisher 제공
    var dayLogPublisher: AnyPublisher<DayLog, Never> {
        dayLogSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    // 기존: 전체 경로를 하나의 배열로 반환
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
    
    // 수정: 각 섹션별로 좌표 배열을 반환
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
    private func loadTargetDayLog(date: Date) {
        Task {
            guard let dayLog = try await dayLogUseCase.getDayLogByDate(date) else { return }
            
            // 각 Section의 첫 지점 timestamp를 기준으로 내림차순(최신순) 정렬
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
            
            dayLogSubject.send(sortedDayLog)
            output.send(.loadedDayLog(sortedDayLog))
        }
    }

    
    func deleteDayLog() async throws {
            try await dayLogUseCase.deleteDayLogByDate(date)
        }
    
    func refreshDayLog() {
            loadTargetDayLog(date: date)
        }
}
