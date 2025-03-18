//
//  DayLogMapping.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//

import Foundation

extension DayLogDTO {
    func toEntity() -> DayLog? {
        guard let date = self.date,
              let locationName = self.locationName,
              let trackImage = self.trackImage,
              let title = self.title
        else { return nil }
              
        return DayLog(
            date: date,
            locationName: locationName,
            weather: Int(weather),
            temperature: Int(temperature),
            trackImage: trackImage,
            title: title,
            level: Int(level),
            totalTime: totalTime,
            totalDistance: totalDistance,
            totalSteps: Int(totalSteps),
            sections: []
        )
    }
}
