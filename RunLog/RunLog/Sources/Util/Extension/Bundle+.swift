//
//  Bundle+.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
extension Bundle {
    var weatherKey: String? {
        return infoDictionary?["API_KEY"] as? String
    }
}
