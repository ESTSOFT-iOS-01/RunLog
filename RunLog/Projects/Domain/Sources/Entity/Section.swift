//
//  Section.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

public struct Section: Equatable {
    public var distance: Double
    public var steps: Int
    public var route: [Point]

    public init(distance: Double, steps: Int, route: [Point]) {
        self.distance = distance
        self.steps = steps
        self.route = route
    }
}

public struct Point: Equatable {
    public var latitude: Double
    public var longitude: Double
    public var timestamp: Date

    public init(latitude: Double, longitude: Double, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
