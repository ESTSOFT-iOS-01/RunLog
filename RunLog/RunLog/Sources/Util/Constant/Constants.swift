//
//  Constants.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import Foundation

struct Constants {
    static let allRoads: [Road] = [
        Road(name: "마라톤", distance: 42.195, icon: RLIcon.medal.name),
        Road(name: "서울둘레길", distance: 156.5, icon: RLIcon.flag.name),
        Road(name: "제주올레길", distance: 437.0, icon: RLIcon.mandarin.name),
        Road(name: "국토대장정", distance: 580.0, icon: RLIcon.korea.name),
        Road(name: "산티아고 순례길", distance: 800.0, icon: RLIcon.church.name),
        Road(name: "지구 둘레길", distance: 40075, icon: RLIcon.earth.name),
        Road(name: "지구에서 달까지", distance: 385000, icon: RLIcon.rocket.name)
    ]
    
    // MARK: - 날씨 정보
    enum WeatherCondition {
        case thunderstorm // 뇌우
        case drizzle      // 이슬비
        case rain         // 비
        case snow         // 눈
        case mist         // 안개
        case clear        // 맑음
        case clouds       // 흐림 / 구름 많음
        case unknown      // 알 수 없음
        
        static func from(_ id: Int) -> WeatherCondition {
            switch id {
            case 200...232: return .thunderstorm
            case 300...321: return .drizzle
            case 500...531: return .rain
            case 600...622: return .snow
            case 701, 711, 721, 741: return .mist
            case 800: return .clear
            case 801...804: return .clouds
            default: return .unknown
            }
        }
        
        var description: String {
            switch self {
            case .thunderstorm: return "뇌우"
            case .drizzle: return "이슬비"
            case .rain: return "비"
            case .snow: return "눈"
            case .mist: return "안개"
            case .clear: return "맑음"
            case .clouds: return "구름 많음"
            case .unknown: return "알 수 없음"
            }
        }
    }
    
    // MARK: - 대기질 정보
    enum AqiLevel: Int, CaseIterable {
        case good = 1 // 좋음
        case fair = 2 // 보통
        case moderate = 3 // 나쁨
        case poor = 4 // 매우 나쁨
        case veryPoor = 5 // 위험
        case unknown = -1 // 알 수 없음
        
        static func from(_ value: Int) -> AqiLevel {
            return AqiLevel(rawValue: value) ?? .unknown
        }
        
        var description: String {
            switch self {
            case .good: return "좋음"
            case .fair: return "보통"
            case .moderate: return "나쁨"
            case .poor: return "매우 나쁨"
            case .veryPoor: return "매우 나쁨"
            case .unknown: return "정보 없음"
            }
        }
    }
}
