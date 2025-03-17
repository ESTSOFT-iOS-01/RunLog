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
        let dayLogs = CurrentValueSubject<[DayLog], Never>([])
    }
    
    private(set) var output: Output = .init()
    private let input = PassthroughSubject<Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
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
                    self?.loadAllDayLogs()
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
    private func loadAllDayLogs() {
        output.dayLogs.send(DummyData.dummyDayLogs)
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
