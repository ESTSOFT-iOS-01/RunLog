//
//  Section.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import Foundation

struct Section {
  var distance: Double
  var steps: Int
  var route: [Point]
}

struct Point {
  var latitude: Double
  var longitude: Double
  var timestamp: Date
}
