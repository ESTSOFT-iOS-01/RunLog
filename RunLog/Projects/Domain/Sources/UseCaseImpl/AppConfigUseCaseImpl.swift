//
//  AppConfigUsecaseImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//
import RLUtil

import Foundation

public final class AppConfigUseCaseImpl: AppConfigUseCase {

    private let appConfigRepository: AppConfigRepository
    
    public init(appConfigRepository: AppConfigRepository) {
        self.appConfigRepository = appConfigRepository
        
        Task {
            do {
                try await self.appConfigRepository.createAppConfig(AppConfig(nickname: "RunLogger", totalDistance: 0, streakDays: 0, totalDays: 0, unitDistance: 10.0))
            } catch {
                print("repo error : \(error)")
            }
        }

    }
    
    public func getUnitDistance() async throws -> Double {
//        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.unitDistance
    }
    
    public func getNickname() async throws -> String {
//        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.nickname
    }
    
    public func getUserIndicators() async throws -> (streakDays: Int, totalDays: Int) {
//        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return (config.streakDays, config.totalDays)
    }
    
    public func getTotalDistance() async throws -> Double {
//        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.totalDistance
    }
    
    public func getDistanceIndicators() async throws -> (roadName: String, count : Double) {
//        print("Impl:", #function)
        
        let totalDistance = try await appConfigRepository.readAppConfig().totalDistance
        
        let eligibleRoads = Constants.allRoads.filter { road in
            road.distance * 0.5 <= totalDistance
        }
        
        guard let selectedRoad = eligibleRoads.randomElement() else {
            return ("마라톤", totalDistance / 42.195)
        }
        
        return (selectedRoad.name, totalDistance / selectedRoad.distance)
    }
    
    public func updateUnitDistance(_ unitDistance: Double) async throws {
//        print("Impl:", #function)
        
        var config = try await appConfigRepository.readAppConfig()
        config.unitDistance = unitDistance
        
        try await appConfigRepository.updateAppConfig(config)
    }
    
    public func updateNickname(_ nickname: String) async throws {
//        print("Impl:", #function)
        
        var config = try await appConfigRepository.readAppConfig()
        config.nickname = nickname
        
        try await appConfigRepository.updateAppConfig(config)
    }
    
}
