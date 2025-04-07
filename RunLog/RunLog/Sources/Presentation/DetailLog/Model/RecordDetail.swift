//
//  RecordDetail.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

/// 각 기록 섹션의 세부 정보를 담는 모델
struct RecordDetail {
    let timeRange: String    // 예: "06:12 - 06:18"
    let distance: String     // 예: "1.81km"
    let steps: String        // 예: "345"
    let route: [Point]       // 해당 섹션의 경로 좌표 배열
}

extension RecordDetail {
    /// Section 데이터를 기반으로 RecordDetail을 생성하는 생성자
    /// - Parameter section: 원본 Section 데이터
    init(from section: Section) {
        // Section의 route 배열을 timestamp 기준으로 오름차순 정렬
        let sortedRoute = section.route.sorted { $0.timestamp < $1.timestamp }
        let startTime = sortedRoute.first?.timestamp
        let endTime = sortedRoute.last?.timestamp
        
        // 시작 시간과 종료 시간을 "HH:mm" 형식의 문자열로 변환하여 timeRange 생성
        let timeRange: String
        if let start = startTime, let end = endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeRange = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else {
            timeRange = "N/A"
        }
        
        self.timeRange = timeRange
        // 거리와 걸음수는 형식에 맞게 문자열로 변환
        self.distance = String(format: "%.2fkm", section.distance)
        self.steps = "\(section.steps)"
        self.route = section.route
    }
}
