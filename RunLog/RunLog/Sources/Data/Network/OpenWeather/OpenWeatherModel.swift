//
//  OpenWeatherModel.swift
//  RunLog
//
//  Created by 심근웅 on 3/21/25.
//

import Foundation

// MARK: - OpenWeather Current Weather Response 형식
struct WeatherResponse: Codable {
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
        let id: Int
        let description: String
    }
    
    let main: Main
    let weather: [Weather]
}

// MARK: - OpenWeather AQI Response 형식
struct AQIResponse: Codable {
    struct AQIList: Codable {
        struct Main: Codable {
            let aqi: Int
        }
        let main: Main
    }
    let list: [AQIList]
}
