//
//  OpenWeatherService.swift
//  RunLog
//
//  Created by 심근웅 on 3/19/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

enum OpenWeatherEndpoint {
    case airQuality(lat: Double, lon: Double)
    case weather(lat: Double, lon: Double)
}
extension OpenWeatherEndpoint: TargetType {
    // MARK: - 기본 도메인
    public var baseURL: URL {
        guard let url = URL(string: API.openWeatherURL.rawValue) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    // MARK: - 도메인 하위 상세 주소 정의
    public var path: String {
        switch self {
        case .airQuality:
            return "/air_pollution"
        case .weather:
            return "/weather"
        }
    }
    // MARK: - 메서드 방식
    public var method: Moya.Method {
        return .get
    }
    // MARK: - 파라미터
    public var task: Moya.Task {
        switch self {
        case .airQuality(let lat, let lon):
            return .requestParameters(
                parameters: [
                    "lat": lat,
                    "lon": lon,
                    "appid": Bundle.main.weatherKey ?? ""
                ],
                encoding: URLEncoding.queryString)
        case .weather(let lat, let lon):
            return .requestParameters(
                parameters: [
                    "lat": lat,
                    "lon": lon,
                    "appid": Bundle.main.weatherKey ?? "",
                    "units": "metric",
                    "lang": "kr"
                ],
                encoding: URLEncoding.queryString)
        }
    }
    // MARK: - 헤더, 보통 비슷하게 사용
    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
// MARK: - OpenWeather Current Weather Response 형식
struct WeatherResponse: Codable {
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
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
// MARK: - API 요청을 담당
final class OpenWeatherService: NetworkService {
    let provider = MoyaProvider<OpenWeatherEndpoint>()
    
    func fetchAirQuality(lat: Double, lon: Double) -> AnyPublisher<AQIResponse, NetworkError> {
        return request(.airQuality(lat: lat, lon: lon), responseType: AQIResponse.self)
    }
    func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, NetworkError> {
        return request(.weather(lat: lat, lon: lon), responseType: WeatherResponse.self)
    }
}
