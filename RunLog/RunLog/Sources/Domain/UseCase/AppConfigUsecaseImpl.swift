//
//  AppConfigUsecaseImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//

import Foundation

final class AppConfigUsecaseImpl: AppConfigUsecase {

    private let appConfigRepository: AppConfigRepository
    
    init(appConfigRepository: AppConfigRepository) {
        self.appConfigRepository = appConfigRepository
    }
    
    func getUnitDistance() async throws -> Double {
        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.unitDistance
    }
    
    func getNickname() async throws -> String {
        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.nickname
    }
    
    func getUserIndicators() async throws -> (streakDays: Int, totalDays: Int) {
        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return (config.streakDays, config.totalDays)
    }
    
    func getTotalDistance() async throws -> Double {
        print("Impl:", #function)
        
        let config = try await appConfigRepository.readAppConfig()
        return config.totalDistance
    }
    
    func updateUnitDistance(_ unitDistance: Double) async throws {
        print("Impl:", #function)
        var config = try await appConfigRepository.readAppConfig()
        config.unitDistance = unitDistance
        
        try await appConfigRepository.updateAppConfig(config)
    }
    
    func updateNickname(_ nickname: String) async throws {
        print("Impl:", #function)
        var config = try await appConfigRepository.readAppConfig()
        config.nickname = nickname
        
        try await appConfigRepository.updateAppConfig(config)
    }
    
}
