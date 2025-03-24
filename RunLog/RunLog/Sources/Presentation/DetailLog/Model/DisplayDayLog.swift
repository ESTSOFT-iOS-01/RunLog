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
        let splitted = dayLog.locationName.split(separator: " ").map { String($0) }
        
        if splitted.isEmpty {
            // 토큰이 전혀 없는 경우
            self.locationName = ""
        }
        else if splitted.count == 1 {
            // 예) "서울특별시", "대구광역시"
            self.locationName = splitted[0]
        }
        else {
            // splitted.count >= 2
            let first = splitted[0]
            let second = splitted[1]
            
            // 두 번째 토큰이 "시"로 끝나면(경산시, 수원시 등) => 2개 토큰 유지
            if second.hasSuffix("시") {
                self.locationName = first + " " + second
            } else {
                // 그 외(구, 동 등)는 필요 없으니 첫 토큰만
                self.locationName = first
            }
        }
        
        self.weather = Constants.WeatherCondition.from(dayLog.weather).description
        self.temperature = dayLog.temperature
        self.title = dayLog.title
        self.level = dayLog.level.toLevelDescription()
        self.totalTime = dayLog.totalTime
        self.totalDistance = dayLog.totalDistance
        self.totalSteps = dayLog.totalSteps
    }
}
