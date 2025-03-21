//
//  Log.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import Combine

final class LogViewModel {
    
    // MARK: - 사용자의 Input 정의
    enum Input {
        case viewWillAppear
    }
    
    
    // MARK: - UI에 관여하는 Output
    struct Output {
        let groupedDayLogs = CurrentValueSubject<[Date: [DayLog]], Never>([:])
        let sortedKeys = CurrentValueSubject<[Date], Never>([])
        let distanceUnit = CurrentValueSubject<Double, Never>(0.0)
    }
    
    private(set) var output: Output = .init()
    private let input = PassthroughSubject<Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    @Dependency private var appConfigUseCase: AppConfigUsecase
    
    // MARK: - Init
    init() {
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .viewWillAppear:
                    self?.loadDatas()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 이벤트를 send
    func send(_ event: Input) {
        input.send(event)
    }
}

extension LogViewModel {
    // MARK: - private Functions
    private func loadDatas() {
        Task {
            
            let dayLogs = try await dayLogUseCase.getAllDayLogs()
            // TODO: Appconfig 들어오면 주석 풀기
            // let distanceUnit = try await appConfigUseCase.getUnitDistance()
            let distanceUnit = 5.0
            
            let groupedDayLogs = Dictionary(grouping: dayLogs) { dayLog in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month], from: dayLog.date)
                return calendar.date(from: components) ?? dayLog.date
            }
            
            output.distanceUnit.send(distanceUnit)
            output.groupedDayLogs.send(groupedDayLogs)
            output.sortedKeys.send(groupedDayLogs.keys.sorted(by: >))
        }
    }
}


enum DummyData {
    static let dummyDayLogs: [DayLog] = [
        DayLog(
            date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 4)) ?? Date(),
            locationName: "서울",
            weather: 1,
            temperature: 5,
            trackImage: Data(),
            title: "아침 산책",
            level: 2,
            totalTime: 1800,
            totalDistance: 0.0,
            totalSteps: 3000,
            sections: []
        )
    ]
}
