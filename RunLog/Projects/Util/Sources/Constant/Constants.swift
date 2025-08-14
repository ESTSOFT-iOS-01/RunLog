//
//  Constants.swift
//  RunLog
//
//  Created by 김도연 on 3/21/25.
//

import Foundation

public struct Road {
    public let name: String
    public let distance: Double
    public let iconName: String
}

public struct Constants {
    public static let levels = ["매우 쉬움", "쉬움", "보통", "어려움", "매우 어려움"]
    
    public static let allRoads: [Road] = [
        Road(name: "마라톤", distance: 42.195, iconName: "Medal"),
        Road(name: "서울둘레길", distance: 156.5, iconName: "Flag"),
        Road(name: "제주올레길", distance: 437.0, iconName: "Mandarin"),
        Road(name: "국토대장정", distance: 580.0, iconName: "Korea"),
        Road(name: "산티아고 순례길", distance: 800.0, iconName: "Church"),
        Road(name: "지구 둘레길", distance: 40075, iconName: "Earth"),
        Road(name: "지구에서 달까지", distance: 385000, iconName: "Rocket")
    ]
    
    public enum MotivationMessage {
        case goodWeather
        case keepGoing
        case dogWalk
        
        public var iconName: String {
            switch self {
            case .goodWeather:
                return "walkMan"
            case .keepGoing:
                return "walkGirl"
            case .dogWalk:
                return "walkDog"
            }
        }
        
        public var message: String {
            switch self {
            case .goodWeather:
                return "날씨 좋은 날에 산뜻한 러닝 어때요?"
            case .keepGoing:
                return "지금까지 잘 해왔어요! 앞으로도 화이팅!"
            case .dogWalk:
                return "기다리고 있었어요! 산책 가요!"
            }
        }
        
        public static var random: MotivationMessage {
            [goodWeather, keepGoing, dogWalk].randomElement()!
        }
    }
    
    public enum LocationMessage {
        case unknown
        case consultingWithMap
        case detectingFootsteps
        case connectingGPS
        
        public var message: String {
            switch self {
            case .unknown:
                return "지구 어딘가에서..."
            case .consultingWithMap:
                return "지도 앱과 상의 중..."
            case .detectingFootsteps:
                return "발걸음을 감지하는 중..."
            case .connectingGPS:
                return "GPS 연결 중..."
            }
        }
        
        /// 위치를 받아오는 과정에서 랜덤한 메시지를 띄웁니다.
        public static var random: LocationMessage {
            [unknown, consultingWithMap, detectingFootsteps, connectingGPS].randomElement()!
        }
    }
    
    // MARK: - 날씨 정보
    public enum WeatherCondition {
        case thunderstorm // 뇌우
        case drizzle      // 이슬비
        case rain         // 비
        case snow         // 눈
        case mist         // 안개
        case clear        // 맑음
        case clouds       // 흐림 / 구름 많음
        case unknown      // 알 수 없음
        
        public static func from(_ id: Int) -> WeatherCondition {
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
        
        public var description: String {
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
    public enum AqiLevel: Int, CaseIterable {
        case good = 1 // 좋음
        case fair = 2 // 보통
        case moderate = 3 // 나쁨
        case poor = 4 // 매우 나쁨
        case veryPoor = 5 // 위험
        case unknown = -1 // 알 수 없음
        
        public static func from(_ value: Int) -> AqiLevel {
            return AqiLevel(rawValue: value) ?? .unknown
        }
        
        public var description: String {
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
