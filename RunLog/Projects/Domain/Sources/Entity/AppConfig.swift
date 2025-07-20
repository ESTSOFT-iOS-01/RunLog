//
//  AppConfig.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

public struct AppConfig: Equatable {
    public var nickname: String
    public var totalDistance: Double
    public var streakDays: Int
    public var totalDays: Int
    public var unitDistance: Double

    public init(
        nickname: String,
        totalDistance: Double,
        streakDays: Int,
        totalDays: Int,
        unitDistance: Double
    ) {
        self.nickname = nickname
        self.totalDistance = totalDistance
        self.streakDays = streakDays
        self.totalDays = totalDays
        self.unitDistance = unitDistance
    }
}
