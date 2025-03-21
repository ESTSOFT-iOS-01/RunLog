//
//  RecordDetail.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

struct RecordDetail {
    let timeRange: String    // 예: "06:12 - 06:18"
    let distance: String     // 예: "1.81km"
    let steps: String        // 예: "345"
    let route: [Point]
}

extension RecordDetail {
    /// Section 데이터를 기반으로 RecordDetail 생성
    init(from section: Section) {
        // route의 첫번째와 마지막 timestamp를 이용하여 timeRange 생성
        let startTime = section.route.first?.timestamp
        let endTime = section.route.last?.timestamp
        let timeRange: String
        if let start = startTime, let end = endTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeRange = "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        } else {
            timeRange = "N/A"
        }
        
        self.timeRange = timeRange
        self.distance = String(format: "%.2fkm", section.distance)
        self.steps = "\(section.steps)"
        self.route = section.route
    }
}
