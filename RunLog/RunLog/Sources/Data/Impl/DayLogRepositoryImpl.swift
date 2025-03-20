////
////  DayLogRepositoryImpl.swift
////  RunLog
////
////  Created by 신승재 on 3/18/25.
////
//
//import Foundation
//import CoreData
//
//final class DayLogRepositoryImpl: DayLogRepository {
//    
//    private let context: NSManagedObjectContext
//    
//    init(context: NSManagedObjectContext) {
//        self.context = context
//    }
//    
//    func createDayLog(_ dayLog: DayLog) async throws {
//        try await context.perform {
//            let dto = DataMapper.toDTO(dayLog, context: self.context)
//            self.context.insert(dto)
//            try self.context.save()
//        }
//    }
//

