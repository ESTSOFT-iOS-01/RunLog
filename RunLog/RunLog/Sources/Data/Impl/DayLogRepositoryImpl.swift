//
//  DayLogRepositoryImpl.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//

import Foundation
import CoreData

final class DayLogRepositoryImpl: DayLogRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createDayLog(_ dayLog: DayLog) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let data = DataMapper.toDTO(dayLog, context: self.context)
            //self.context.insert(data)
            try self.context.save()
        }
    }
    
    func readDayLog(date: Date) async throws -> DayLog {
        print("Impl: ", #function)
        
        return try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw CoreDataError.modelNotFound
            }
            guard let model = DataMapper.toEntity(data) else {
                throw CoreDataError.conversionError
            }
            
            return model
        }
    }
    
    func readAllDayLogs() async throws -> [DayLog] {
        print("Impl: ", #function)
        
        return try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            let datas = try self.context.fetch(fetchRequest)
            
            return datas.compactMap { DataMapper.toEntity($0) }
        }
    }

    func updateDayLog(_ dayLog: DayLog) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                dayLog.date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw CoreDataError.modelNotFound
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
        }
    }

    func deleteDayLog(date: Date) async throws {
        print("Impl: ", #function)
        
        try await context.perform {
            let fetchRequest: NSFetchRequest<DayLogDTO> = DayLogDTO.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "date == %@",
                date as CVarArg
            )
            
            guard let data = try self.context.fetch(fetchRequest).first else {
                throw CoreDataError.modelNotFound
            }
            
            self.context.delete(data)
            try self.context.save()
        }
    }
}
