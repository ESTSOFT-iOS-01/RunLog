//
//  DayLogRepositoryImpl.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//
import RLDomain

import Foundation
import CoreData

public final class DayLogRepositoryImpl: DayLogRepository {
    
    private let context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func createDayLog(_ dayLog: DayLog) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                dayLog.date as CVarArg
            )
            
            let existing = try self.context.fetch(fetchRequest)
            if !existing.isEmpty {
                throw DataError.modelAlreadyExist
            }
            
            let data = DataMapper.toDTO(dayLog, context: self.context)
            self.context.insert(data)
            try self.context.save()
        }
    }
    
    public func readDayLog(date: Date) async throws -> DayLog {
        print("Impl: ", #function)
        
        return try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw DataError.modelNotFound
            }
            guard let model = DataMapper.toEntity(data) else {
                throw DataError.conversionError
            }
            
            return model
        }
    }
    
    public func readAllDayLogs() async throws -> [DayLog] {
        print("Impl: ", #function)
        
        return try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            let datas = try self.context.fetch(fetchRequest)
            
            return datas.compactMap { DataMapper.toEntity($0) }
        }
    }

    public func updateDayLog(_ dayLog: DayLog) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                dayLog.date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw DataError.modelNotFound
            }
            
            data.trackImage = dayLog.trackImage
            data.title = dayLog.title
            data.level = Int16(dayLog.level)
            data.totalTime = dayLog.totalTime
            data.totalDistance = dayLog.totalDistance
            data.totalSteps = Int32(dayLog.totalSteps)
            data.sections = NSSet(array: dayLog.sections.map {
                DataMapper.toDTO($0, context: self.context)
            })
            
            try self.context.save()
        }
    }

    public func deleteDayLog(date: Date) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw DataError.modelNotFound
            }
            
            self.context.delete(data)
            try self.context.save()
        }
    }
}
