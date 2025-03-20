//
//  AppConfigRepositoryImpl.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//

import Foundation
import CoreData

final class AppConfigRepositoryImpl: AppConfigRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createAppConfig(_ config: AppConfig) async throws {
        let _ = DataMapper.toDTO(config, context: context)
        do {
            try context.save()
        } catch {
            throw AppConfigError.saveFailed
        }
    }
    
    func readAppConfig() async throws -> AppConfig {
        let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
        let results = try context.fetch(fetchRequest)

        guard let entity = results.first else {
            throw AppConfigError.notFound
        }

        guard let config = DataMapper.toEntity(entity) else {
            throw AppConfigError.dataConversionFailed
        }

        return config
    }
    
    func updateAppConfig(_ config: AppConfig) async throws {
        let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
        let results = try context.fetch(fetchRequest)

        guard let entity = results.first else {
            throw AppConfigError.notFound
        }
        
        entity.nickname = config.nickname
        entity.streakDays = Int32(config.streakDays)
        entity.totalDays = Int32(config.totalDays)
        entity.totalDistance = config.totalDistance
        entity.unitDistance = config.unitDistance
        
        do {
            try context.save()
        } catch {
            throw AppConfigError.saveFailed
        }
    }
    
    func deleteAppConfig() async throws {
        let fetchRequest: NSFetchRequest<AppConfigDTO> = AppConfigDTO.fetchRequest()
        let results = try context.fetch(fetchRequest)

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
