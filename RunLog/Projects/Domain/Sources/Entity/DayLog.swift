//
//  DayLog.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

public struct DayLog: Equatable {
    public let date: Date
    public let locationName: String
    public let weather: Int
    public let temperature: Double
    
    public var trackImage: Data
    public var title: String
    public var level: Int
    public var totalTime: TimeInterval
    public var totalDistance: Double
    public var totalSteps: Int
    public var sections: [Section]

    public init(
        date: Date,
        locationName: String,
        weather: Int,
        temperature: Double,
        trackImage: Data,
        title: String,
        level: Int,
        totalTime: TimeInterval,
        totalDistance: Double,
        totalSteps: Int,
        sections: [Section]
    ) {
        self.date = date
        self.locationName = locationName
        self.weather = weather
        self.temperature = temperature
        self.trackImage = trackImage
        self.title = title
        self.level = level
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.totalSteps = totalSteps
        self.sections = sections
    }
}


//extension DayLog {
//    /// DayLog의 각 section을 RecordDetail 배열로 변환
//    func toRecordDetails() -> [RecordDetail] {
//        return self.sections.map { RecordDetail(from: $0) }
//    }
//}
