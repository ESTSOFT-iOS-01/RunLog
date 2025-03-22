//
//  CLPlacemark+.swift
//  RunLog
//
//  Created by 심근웅 on 3/21/25.
//

import Foundation
import MapKit

// MARK: - 위치 정보 -> 한글
extension CLPlacemark {
    func placemarksToString() -> String {
        var state: String = "" // 도, 광역시
        var city: String = "" // 시, 군, 구
        var district: String = "" // 동, 읍, 면
        if let subLocal = self.subLocality, subLocal.hasSuffix("동") {
            district = subLocal
        }
        let description: String = String(
            self.description
                .split(separator: ",")
                .filter{ $0.contains("대한민국") }
                .first
            ?? "")
        let components = description.split(separator: " ").map { String($0) }
        for component in components {
            if state == "" && (component.hasSuffix("특별시") || component.hasSuffix("광역시") || component.hasSuffix("도")) {
                state = component
            }else if city == "" && (component.hasSuffix("시") || component.hasSuffix("군") || component.hasSuffix("구")) {
                city = component
            }else if district == "" && (component.hasSuffix("동") || component.hasSuffix("읍") || component.hasSuffix("면") || component.hasSuffix("로")) {
                district = component
            }
        }
        return district.isEmpty ? "\(state) \(city)" : "\(state) \(city) \(district)"
    }
}
