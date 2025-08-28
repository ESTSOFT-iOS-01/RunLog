//
//  Running.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//
import RLInject
import RLDomain

import UIKit
import Combine
import MapKit

final class RunningViewModel {
    
    // MARK: - Input
    enum Input {
        case requestRunningStop // 운동종료 요청
    }
    
    let input = PassthroughSubject<Input, Never>()
    
    // MARK: - Output
    enum Output {
        case currentTime(TimeInterval)
        case currentDistance(Double)
        case currentLocation(CLLocation) // 사용자 위치 데이터
        case currentSteps(Int) // 운동 걸음 수 데이터
        case currentRoutes([CLLocationCoordinate2D]) // 지도에 라인을 그림
    }
    
    let output = PassthroughSubject<Output, Never>()
    
    // MARK: - Dependency
    @Dependency private var pedometerProvider: PedometerProvider
    @Dependency private var locationProvider: LocationProvider
    @Dependency private var dayLogUseCase: DayLogUseCase
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private var provider = RunningDataProvider.shared
    private var startTime: Date = .now
    
    private(set) var totalDistance = 0.0
    private(set) var totalSteps = 0
    private(set) var routes: [Point] = []
    
    // MARK: - Init
    init() {
        startTimer()
    }
    
    // MARK: - Binding
    func bind() {
        self.input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .requestRunningStop:
                    saveCurrentSession()
                }
            }
            .store(in: &cancellables)
        
        self.pedometerProvider.steps
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.pedometerProvider.startPedometer()
            })
            .sink { [weak self] steps in
                self?.output.send(.currentSteps(steps))
                self?.totalSteps = steps
            }
            .store(in: &cancellables)
        
        self.locationProvider.locations
            .sink { [weak self] locations in
                self?.output.send(.currentLocation(locations))
            }
            .store(in: &cancellables)
        
        self.locationProvider.locations
            .scan((prev: CLLocation?(nil), total: 0.0)) { state, newLocation in
                let (prev, total) = state
                guard let prev else { return (newLocation, 0.0) }
                let distance = newLocation.distance(from: prev) / 1000
                
                return (newLocation, total + distance)
            }
            .map { $0.total }
            .sink { [weak self] distance in
                self?.output.send(.currentDistance(distance))
                self?.totalDistance = distance
            }
            .store(in: &cancellables)
        
        self.locationProvider.locations
            .prepend(locationProvider.locations)
            .scan([CLLocationCoordinate2D]()) { routes, newLocation in
                var routes = routes
                routes.append(newLocation.coordinate)
                return routes
            }
            .sink { [weak self] routes in
                self?.output.send(.currentRoutes(routes))
            }
            .store(in: &cancellables)
    }
}


private extension RunningViewModel {
    func startTimer() {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] now in
                guard let self = self else { return }
                let time = now.timeIntervalSince(self.startTime)
                self.output.send(.currentTime(time))
            }
            .store(in: &cancellables)
    }
    
    func saveCurrentSession() {
        Task {
            do {
                let section = Section(
                    distance: self.totalDistance,
                    steps: self.totalSteps,
                    route: self.routes
                )
                try await self.dayLogUseCase.addSectionByDate(.now, section: section)
            } catch {
                print(error)
            }
        }
    }
}
