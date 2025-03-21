//
//  DisplayDayLog.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

// MARK: - DisplayDayLog Model
struct DisplayDayLog {
    let date: Date
    let locationName: String
    let weather: String
    let temperature: Double
    let title: String
    let level: String
    let totalTime: TimeInterval
    let totalDistance: Double
    let totalSteps: Int
}


// MARK: - DisplayDayLog 초기화 추가
extension DisplayDayLog {
    init(from dayLog: DayLog) {
        self.date = dayLog.date
        self.locationName = dayLog.locationName
        self.weather = dayLog.weather.toWeatherDescription()
        self.temperature = dayLog.temperature
        self.title = dayLog.title
        self.level = dayLog.level.toLevelDescription()
        self.totalTime = dayLog.totalTime
        self.totalDistance = dayLog.totalDistance
        self.totalSteps = dayLog.totalSteps
    }
}
