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
import MapKit

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
    static let shared = OpenWeatherService()
    // MARK: - Input & Output
    enum Input {
        case requestUpdate(CLLocation)
    }
    let input = PassthroughSubject<Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    // MARK: - Subject
    private let weatherUpdateSubject = PassthroughSubject<(String, Double), Never>()
    private let aqiUpdateSubject = PassthroughSubject<Int, Never>()
    // MARK: - Publisher
    var weatherUpdatePublisher: AnyPublisher<(String, Double), Never> {
        weatherUpdateSubject.eraseToAnyPublisher()
    }
    var aqiUpdatePublisher: AnyPublisher<Int, Never> {
        aqiUpdateSubject.eraseToAnyPublisher()
    }
    // MARK: - Properties
    let provider = MoyaProvider<OpenWeatherEndpoint>()
    
    private init() {
        bind()
    }
    // MARK: - Bind
    private func bind() {
        self.input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                guard let self = self else { return }
                // 날씨 및 대기질 요청 받으면 두가지 실행 -> 결과는 subject로 뿌림
                switch input {
                case .requestUpdate(let location):
                    self.fetchWeatherData(location: location)
                    self.fetchAqiData(location: location)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 날씨 받아오기
extension OpenWeatherService {
    // MARK: - openWeather로 날씨를 받아옴
    private func fetchWeatherData(location: CLLocation) {
        self.fetchWeather(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .sink { completion in
            if case let .failure(error) = completion {
                print("데이터 요청 실패: \(error.errorMessage)")
            }
        } receiveValue: { response in
            let temperature: Double = response.main.temp
            let condition: String = response.weather.first?.description ?? "알 수 없음"
            self.weatherUpdateSubject.send((condition, temperature))
        }
        .store(in: &cancellables)
    }
    private func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, NetworkError> {
        return request(.weather(lat: lat, lon: lon), responseType: WeatherResponse.self)
    }
}

// MARK: - 대기질 받아오기
extension OpenWeatherService {
    // MARK: - openWeather로 대기질을 받아옴
    private func fetchAqiData(location: CLLocation) {
        self.fetchAqi(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .sink { completion in
            if case let .failure(error) = completion {
                print("데이터 요청 실패: \(error.errorMessage)")
                self.aqiUpdateSubject.send(-1)
            }
        } receiveValue: { response in
            let aqi = response.list.first?.main.aqi ?? 3 // 기본값 '나쁨(3)' 설정
            print("현재 Aqi 값: \(aqi)")
            self.aqiUpdateSubject.send(aqi)
        }
        .store(in: &cancellables)
    }
    private func fetchAqi(lat: Double, lon: Double) -> AnyPublisher<AQIResponse, NetworkError> {
        return request(.airQuality(lat: lat, lon: lon), responseType: AQIResponse.self)
    }
}
