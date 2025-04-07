//
//  DisplayDayLog.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

// MARK: - DisplayDayLog Model
/// 하루 동안의 운동 기록을 표시하기 위한 모델
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
    /// DayLog 모델 데이터를 기반으로 DisplayDayLog를 초기화하는 생성자
    /// - Parameter dayLog: 원본 DayLog 데이터
    init(from dayLog: DayLog) {
        self.date = dayLog.date
        
        // 위치 문자열을 공백으로 분리 후 필요한 토큰만 사용
        let splitted = dayLog.locationName.split(separator: " ").map { String($0) }
        if splitted.isEmpty {
            self.locationName = ""
        } else {
            let first = splitted[0]
            if first.hasSuffix("시") {
                // 첫 번째 토큰이 "시"로 끝나면 첫 번째 토큰만 사용
                self.locationName = first
            } else {
                // 그렇지 않으면, 두 번째 토큰까지 합쳐서 사용 (두 번째 토큰이 없으면 첫 번째 토큰만 사용)
                if splitted.count >= 2 {
                    self.locationName = "\(first) \(splitted[1])"
                } else {
                    self.locationName = first
                }
            }
        }
        
        // 날씨 정보 및 온도, 제목, 난이도, 소요시간, 거리, 걸음수 설정
        self.weather = Constants.WeatherCondition.from(dayLog.weather).description
        self.temperature = dayLog.temperature
        self.title = dayLog.title
        self.level = dayLog.level.toLevelDescription()
        self.totalTime = dayLog.totalTime
        self.totalDistance = dayLog.totalDistance
        self.totalSteps = dayLog.totalSteps
    }
}
