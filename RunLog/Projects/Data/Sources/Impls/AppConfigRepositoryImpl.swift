//
//  AppConfigRepositoryImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//
import RLDomain

import Foundation
import CoreData

public final class AppConfigRepositoryImpl: AppConfigRepository {
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func createAppConfig(_ config: AppConfig) async throws {
//        print("Impl: ", #function)
        
            try await context.perform { [weak self] in
                guard let self = self else {
                    throw AppConfigError.notFound
                }
                
                let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
                let results = try self.context.fetch(fetchRequest)
                
                guard results.isEmpty else {
                    throw AppConfigError.duplicatedObject
                }
                
                let data = DataMapper.toDTO(config, context: self.context)
                self.context.insert(data)
                
                do {
                    try self.context.save()
                } catch {
                    throw AppConfigError.saveFailed
                }
            }
    }
    
    public func readAppConfig() async throws -> AppConfig {
//        print("Impl: ", #function)
        
        return try await context.perform { [weak self] in
            guard let self = self else {
                // 객체가 Nil
                throw AppConfigError.notFound
            }
            
            let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw AppConfigError.notFound
            }
            
            guard let config = DataMapper.toEntity(data) else {
                throw AppConfigError.dataConversionFailed
            }
            
            return config
        }
        
    }
    
    public func updateAppConfig(_ config: AppConfig) async throws {
//        print("Impl: ", #function)
        
        return try await context.perform { [weak self] in
            guard let self = self else {
                // 객체가 Nil
                throw AppConfigError.notFound
            }
            
            let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
            
            guard let entity = try self.context.fetch(fetchRequest).first else {
                throw AppConfigError.notFound
            }
            
            ///  들어온 데이터로 프로퍼티 업데이트
            entity.nickname = config.nickname
            entity.streakDays = Int32(config.streakDays)
            entity.totalDays = Int32(config.totalDays)
            entity.totalDistance = config.totalDistance
            entity.unitDistance = config.unitDistance
            
            do {
                try self.context.save()
            } catch {
                throw AppConfigError.saveFailed
            }
            
        }
    }
    
    public func deleteAppConfig() async throws {
//        print("Impl: ", #function)
        
        return try await context.perform { [weak self] in
            guard let self = self else {
                // 객체가 Nil
                throw AppConfigError.notFound
            }
            
            let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
            let results = try self.context.fetch(fetchRequest)
            
            // 빈 배열(데이터 하나도 없는 경우)
            guard !results.isEmpty else {
                throw AppConfigError.notFound
            }
            
            for entity in results {
                context.delete(entity)
            }
            
            do {
                try context.save()
            } catch {
                throw AppConfigError.deleteFailed
            }
        }
    }
    
}
