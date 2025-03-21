//
//  DayLogRepository.swift
//  RunLog
//
//  Created by 신승재 on 3/18/25.
//

import Foundation

protocol DayLogRepository {
    /// 새로운 DayLog를 생성합니다.
    /// - Parameter dayLog: 저장할 DayLog 도메인 모델
    /// - Throws: 저장 실패 시 `CoreDataError` 발생
    func createDayLog(_ dayLog: DayLog) async throws
    
    /// 특정 날짜의 DayLog를 조회합니다.
    /// - Parameter date: 조회할 DayLog의 날짜
    /// - Returns: 해당 날짜에 해당하는 DayLog 도메인 모델
    /// - Throws: 모델이 존재하지 않거나 변환 실패 시 `CoreDataError` 발생
    @discardableResult
    func readDayLog(date: Date) async throws -> DayLog
    
    /// 저장된 모든 DayLog를 조회합니다.
    /// - Returns: 전체 DayLog 도메인 모델 배열
    /// - Throws: 조회 또는 변환 실패 시 `CoreDataError` 발생
    func readAllDayLogs() async throws -> [DayLog]
    
    /// 특정 DayLog를 업데이트합니다.
    /// - Parameter dayLog: 수정할 DayLog 도메인 모델
    /// - Throws: 대상이 존재하지 않거나 저장 실패 시 `CoreDataError` 발생
    func updateDayLog(_ dayLog: DayLog) async throws
    
    /// 특정 날짜의 DayLog를 삭제합니다.
    /// - Parameter date: 삭제할 DayLog의 날짜
    /// - Throws: 삭제 대상이 존재하지 않거나 삭제 실패 시 `CoreDataError` 발생
    func deleteDayLog(date: Date) async throws
}
