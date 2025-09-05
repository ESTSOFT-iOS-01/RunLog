//
//  Run.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//
import RLDomain
import RLUtil
import RLInject

import UIKit
import Combine
import MapKit

final class RunHomeViewModel {
    
    
    // MARK: - Input & Output
    enum Input {
        case requestRunningStart
    }
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case currentLocation(CLLocation)
        case currentLocationName(String)
        case weatherUpdate(String)  // TODO: 수정해야함
        case responseRoadRecord(NSMutableAttributedString) // TODO: 수정해야함
    }
    
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private(set) var currentLocationName: String = ""
    
    // MARK: - Usecase
    @Dependency private var locationProvider: LocationProvider
    @Dependency private var dayLogUseCase: DayLogUseCase
    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    // MARK: - Init
    init() {
        self.getDistanceIndicator()
    }
    
    // MARK: - Binding
    func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                
                switch input {
                    case .requestRunningStart:
                    
                    Task {
                        do {
                            try await self.dayLogUseCase.initializeDayLog(
                                locationName: self.currentLocationName,
                                weather: 0, // TODO: 수정해야함
                                temperature: 0.0 // TODO: 수정해야함
                            )
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        
        self.locationProvider.locations
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.locationProvider.startUpdating()
            })
            .sink { [weak self] locations in
                guard let self = self else { return }
                
                self.output.send(.currentLocation(locations))
                
                Task {
                    do {
                        let locationName = try await self.fetchCityName(from: locations)
                        self.currentLocationName = locationName
                        self.output.send(.currentLocationName(locationName))
                    } catch {
                        print(error)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - 날씨 레이블 형태로 변경
extension RunHomeViewModel {
    private func toWeatherString(_ weather: (Int, Double), _ aqi: Int) -> String {
        
        var formattedString = ""
        
        if weather.0 == -1 { formattedString = "알 수 없음" }
        else {
            let condition = Constants.WeatherCondition.from(weather.0).description
            let temperature = weather.1.toString(withDecimal: 1)
            let aqiLevel = Constants.AqiLevel.from(aqi).description
            formattedString = "\(condition) | \(temperature)°C 대기질 \(aqiLevel)"
        }
        return formattedString
    }
    
    private func fetchCityName(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        let placemarks = try await geocoder.reverseGeocodeLocation(location)

        guard let placemark = placemarks.first else {
            throw NSError(domain: "GeoError", code: 0)
        }

        let city = placemark.locality
            ?? placemark.subAdministrativeArea
            ?? placemark.administrativeArea
            ?? ""

        let district = placemark.subLocality ?? ""

        if !city.isEmpty && !district.isEmpty {
            return "\(city) \(district)"
        } else {
            return city.isEmpty ? district : city
        }
    }
    
    private func getDistanceIndicator() {
        Task {
            let nickname = try await appConfigUseCase.getNickname()
            let (roadName, countData) = try await appConfigUseCase.getDistanceIndicators()
            let count = countData.toString(withDecimal: 2)
            
            let string = """
                         \(nickname) 님은
                         지금까지 \(roadName) \(count)회
                         거리만큼 걸었습니다!
                         """
            
            let attributedString = string.styledText(
                highlightText: "\(roadName) \(count)회",
                baseFont: .RLMainTitle,
                baseColor: .Gray000,
                highlightFont: .RLMainTitle,
                highlightColor: .LightGreen
            )
            
            self.output.send(.responseRoadRecord(attributedString))
        }
    }
}
