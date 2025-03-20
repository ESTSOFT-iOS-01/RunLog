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
    let temperature: Int
    
    var trackImage: Data
    var title: String
    var level: Int
    var totalTime: TimeInterval
    var totalDistance: Double
    var totalSteps: Int
    var sections: [Section]
}
