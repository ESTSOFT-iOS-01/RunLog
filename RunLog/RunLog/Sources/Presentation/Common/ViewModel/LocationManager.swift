//
//  LocationManager.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import Foundation
import UIKit
import MapKit
import WeatherKit

final class LocationManager {
    static var shared: LocationManager = LocationManager()
    
    var curLocationStr: NSAttributedString {
        let str = currentLocation()
        return .RLAttributedString(text: str, font: .Label2, align: .center)
    }
    var curWeatherStr: NSAttributedString {
        let str = currentWeather()
        return .RLAttributedString(text: str, font: .Label2, align: .center)
    }
    
    /// 현재 위치의 도시명을 받아와서 String으로 반환
    private func currentLocation() -> String {
        return "경상남도 창원시"
    }
    /// 현재 위치(currentLocation의 위치)의 날씨, 온도, 미세먼지 농도를 받아와서 String으로 반환
    private func currentWeather() -> String {
        return "흐림 | 12°C, 미세먼지 나쁨"
    }
}
// MARK: -  API 호출 함수
extension LocationManager {
    // 위치를 가지고 날씨를 받아옴
    
}


