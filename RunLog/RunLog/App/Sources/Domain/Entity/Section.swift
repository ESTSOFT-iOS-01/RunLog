//
//  Section.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

struct Section: Equatable {
    var distance: Double
    var steps: Int
    var route: [Point]
}

struct Point: Equatable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
}
