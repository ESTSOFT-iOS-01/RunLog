//
//  DayLogRepository.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//

import Foundation

protocol DayLogRepository {
    func createDayLog(_ dayLog: DayLog) async throws
    func readDayLog(date: Date) async throws -> DayLog
    func updateDayLog(_ dayLog: DayLog) async throws
    func deleteDayLog(date: Date) async throws
}
