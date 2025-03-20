//
//  DayLogUseCaseImpl.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import Foundation

final class DayLogUseCaseImpl: DayLogUseCase {
    
    private let dayLogRepository: DayLogRepository
    private let appConfigRepository: AppConfigRepository
    
    init(
        dayLogRepository: DayLogRepository,
        appConfigRepository: AppConfigRepository
    ) {
        self.dayLogRepository = dayLogRepository
        self.appConfigRepository = appConfigRepository
    }
    
    func initializeDayLog(
        locationName: String,
        weather: Int,
        temperature: Double
    ) async throws {
        print("Impl: ", #function)
        
        let today = Date().toYearMonth
        let initialTitle = "\(today.formattedString(.weekDay)) 러닝"
        
        let newDayLog = DayLog(
            date: today,
            locationName: locationName,
            weather: weather,
            temperature: temperature,
            trackImage: Data(),
            title: initialTitle,
            level: 1,
            totalTime: 0,
            totalDistance: 0.0,
            totalSteps: 0,
            sections: []
        )
        
        try await dayLogRepository.createDayLog(newDayLog)
        
        // TODO: Streak 어떻게 처리할지 고민
    }

    func getDayLogByDate(_ date: Date) async throws -> DayLog? {
        print("Impl: ", #function)
        
        let dayLog = try await dayLogRepository.readDayLog(date: date)
        return dayLog
    }

    func getAllDayLogs() async throws -> [DayLog] {
        print("Impl: ", #function)
        
        let dayLogs = try await dayLogRepository.readAllDayLogs()
        return dayLogs
    }

    func deleteDayLogByDate(_ date: Date) async throws {
        print("Impl: ", #function)
        
        try await dayLogRepository.deleteDayLog(date: date)
    }

    func addSectionByDate(_ date: Date, section: Section) async throws {
        print("Impl: ", #function)
        
        // 1. update 할 DayLog 가져오기
        var targetDayLog = try await dayLogRepository.readDayLog(date: date)
        
        // 2. section에서 시작, 끝 타임 스템프 가져오기
        let startTime = section.route[0].timestamp
        let endTime = section.route[-1].timestamp
        
        // 3. timeinterval로 계산
        targetDayLog.totalTime += endTime.timeIntervalSince(startTime)
        
        // 4. 총 걸음수, 총 거리, 섹션 추가
        targetDayLog.totalSteps += section.steps
        targetDayLog.totalDistance += section.distance
        targetDayLog.sections.append(section)
        
        // 5. 업데이트
        try await dayLogRepository.updateDayLog(targetDayLog)
        
        // 6. 업데이트할 appconfig 가져오기
        var appconfig = try await appConfigRepository.readAppConfig()
        
        // 7. 총 거리수 추가
        appconfig.totalDistance += section.distance
        
        // 8. appconfig 업데이트
        try await appConfigRepository.updateAppConfig(appconfig)
    }

    func getTitleByDate(_ date: Date) async throws -> String {
        print("Impl: ", #function)
        
        let dayLog = try await dayLogRepository.readDayLog(date: date)
        return dayLog.title
    }

    func updateTitleByDate(_ date: Date, title: String) async throws {
        print("Impl: ", #function)
        
        var targetDayLog = try await dayLogRepository.readDayLog(date: date)
        targetDayLog.title = title
        
        try await dayLogRepository.updateDayLog(targetDayLog)
    }

    func getLevelByDate(_ date: Date) async throws -> Int {
        print("Impl: ", #function)
        
        let dayLog = try await dayLogRepository.readDayLog(date: date)
        return dayLog.level
    }

    func updateLevelByDate(_ date: Date, level: Int) async throws {
        print("Impl: ", #function)
        
        var targetDayLog = try await dayLogRepository.readDayLog(date: date)
        targetDayLog.level = level
        
        try await dayLogRepository.updateDayLog(targetDayLog)
    }
}
