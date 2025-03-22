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

// MARK: - API 요청을 담당
final class OpenWeatherService: NetworkService {
    
    // MARK: - Singleton
    static let shared = OpenWeatherService()
    private init() {
        bind()
    }
    
    
    // MARK: - Input & Output
    enum Input {
        case requestWeather(CLLocation)
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case responseWeather(weather: (Int, Double), aqi: Int) // 날씨컨디션, 기온을 제공
    }
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    let provider = MoyaProvider<OpenWeatherEndpoint>()
    
    
    // MARK: - Binding
    private func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestWeather(let location):
                    Publishers.Zip(
                        self.fetchWeatherData(location: location),
                        self.fetchAqiData(location: location)
                    )
                    .sink { completion in
                        if case let .failure(error) = completion {
                            print("데이터 요청 실패: \(error)")
                        }
                    } receiveValue: { [weak self] weather, aqi in
                        guard let self = self else { return }
                        self.output.send(.responseWeather(weather: weather, aqi: aqi))
                    }
                    .store(in: &self.cancellables)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 날씨정보 요청
extension OpenWeatherService {
    private func fetchWeather(lat: Double, lon: Double) -> AnyPublisher<WeatherResponse, NetworkError> {
        return request(.weather(lat: lat, lon: lon), responseType: WeatherResponse.self)
    }
    
    private func fetchWeatherData(location: CLLocation) -> AnyPublisher<(Int, Double), Never> {
        return self.fetchWeather(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .map { response in
            let temperature: Double = response.main.temp
            let condition: Int = response.weather.first?.id ?? -1
            return (condition, temperature)
        }
        .catch { _ in Just((-1, 0.0)) } // 오류 발생 시 기본값 반환
        .eraseToAnyPublisher()
    }
}

// MARK: - 대기질정보 요청
extension OpenWeatherService {
    private func fetchAqi(lat: Double, lon: Double) -> AnyPublisher<AQIResponse, NetworkError> {
        return request(.airQuality(lat: lat, lon: lon), responseType: AQIResponse.self)
    }
    
    private func fetchAqiData(location: CLLocation) -> AnyPublisher<Int, Never> {
        return self.fetchAqi(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        )
        .map { response in
            response.list.first?.main.aqi ?? -1
        }
        .catch { _ in Just(-1) } // 오류 발생 시 기본값 반환
        .eraseToAnyPublisher()
    }
}
