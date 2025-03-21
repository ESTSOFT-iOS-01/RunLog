//
//  CoreDataMapper.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//

import Foundation
import CoreData


// MARK: - ToDTO (Entity Model -> DTO Model)
final class DataMapper {
    
    static func toDTO(_ entity: DayLog, context: NSManagedObjectContext) -> DayLogDTO {
        let dto = DayLogDTO(context: context)
        dto.date = entity.date
        dto.locationName = entity.locationName
        dto.weather = Int16(entity.weather)
        dto.temperature = entity.temperature
        dto.trackImage = entity.trackImage
        dto.title = entity.title
        dto.level = Int16(entity.level)
        dto.totalTime = entity.totalTime
        dto.totalDistance = entity.totalDistance
        dto.totalSteps = Int32(entity.totalSteps)
        
        let sectionDTOs = entity.sections.map { toDTO($0, context: context) }
        dto.sections = NSSet(array: sectionDTOs)
        
        return dto
    }
    
    static func toDTO(_ entity: Section, context: NSManagedObjectContext) -> SectionDTO {
        let dto = SectionDTO(context: context)
        dto.distance = entity.distance
        dto.steps = Int32(entity.steps)
        
        let routeDTOs = entity.route.map { toDTO($0, context: context) }
        dto.route = NSSet(array: routeDTOs)
        
        return dto
    }
    
    static func toDTO(_ entity: Point, context: NSManagedObjectContext) -> PointDTO {
        let dto = PointDTO(context: context)
        dto.latitude = entity.latitude
        dto.longitude = entity.longitude
        dto.timestamp = entity.timestamp
        return dto
    }
    
    static func toDTO(_ entity: AppConfig, context: NSManagedObjectContext) -> AppConfigDTO {
        let dto = AppConfigDTO(context: context)
        dto.nickname = entity.nickname
        dto.streakDays = Int32(entity.streakDays)
        dto.totalDays = Int32(entity.totalDays)
        dto.totalDistance = entity.totalDistance
        dto.unitDistance = entity.unitDistance

        return dto
    }
}


// MARK: - ToEntity (DTO Model -> Entity Model)
extension DataMapper {
    static func toEntity(_ dto: DayLogDTO) -> DayLog? {
        
        guard let date = dto.date,
              let locationName = dto.locationName,
              let trackImage = dto.trackImage,
              let title = dto.title
        else { return nil }
        
        let sections = dto.sections as? Set<SectionDTO>
        
        return DayLog(
            date: date,
            locationName: locationName,
            weather: Int(dto.weather),
            temperature: dto.temperature,
            trackImage: trackImage,
            title: title,
            level: Int(dto.level),
            totalTime: dto.totalTime,
            totalDistance: dto.totalDistance,
            totalSteps: Int(dto.totalSteps),
            sections: sections?.compactMap { toEntity($0) } ?? []
        )
    }
    
    static func toEntity(_ dto: SectionDTO) -> Section? {
        
        let route = dto.route as? Set<PointDTO>
        
        return Section(
            distance: dto.distance,
            steps: Int(dto.steps),
            route: route?.compactMap { toEntity($0) } ?? []
        )
    }
    
    static func toEntity(_ dto: PointDTO) -> Point? {
        
        guard let timestamp = dto.timestamp else { return nil }
        
        return Point(
            latitude: dto.latitude,
            longitude: dto.longitude,
            timestamp: timestamp
        )
    }
    
    static func toEntity(_ dto: AppConfigDTO) -> AppConfig? {
        
        guard let nickname = dto.nickname else { return nil }
        
        return AppConfig(
            nickname: nickname,
            totalDistance: dto.totalDistance,
            streakDays: Int(dto.streakDays),
            totalDays: Int(dto.totalDays),
            unitDistance: dto.unitDistance
        )
    }
    
}
