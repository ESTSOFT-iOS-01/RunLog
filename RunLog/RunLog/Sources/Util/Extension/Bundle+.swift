//
//  Bundle+.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
extension Bundle {
    var weatherKey: String? {
        guard let key = object(forInfoDictionaryKey: "API_KEY") as? String else {
            fatalError("❌ API_KEY가 Info.plist에서 설정되지 않았습니다.")
        }
        return key
    }
}
