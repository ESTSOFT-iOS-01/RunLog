//
//  DayLogUseCaseImpl.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import Foundation

final class DayLogUseCaseImpl: DayLogUseCase {
    
    private let dayLogRepository: DayLogRepository
    
    init(dayLogRepository: DayLogRepository) {
        self.dayLogRepository = dayLogRepository
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
        
        var targetDayLog = try await dayLogRepository.readDayLog(date: date)
        targetDayLog.sections.append(section)
        
        try await dayLogRepository.updateDayLog(targetDayLog)
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
