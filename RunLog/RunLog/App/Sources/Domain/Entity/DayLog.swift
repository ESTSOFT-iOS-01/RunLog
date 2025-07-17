//
//  DayLog.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

struct DayLog: Equatable {
    let date: Date
    let locationName: String
    let weather: Int
    let temperature: Double
    
    var trackImage: Data
    var title: String
    var level: Int
    var totalTime: TimeInterval
    var totalDistance: Double
    var totalSteps: Int
    var sections: [Section]
}


extension DayLog {
    /// DayLog의 각 section을 RecordDetail 배열로 변환
    func toRecordDetails() -> [RecordDetail] {
        return self.sections.map { RecordDetail(from: $0) }
    }
}
