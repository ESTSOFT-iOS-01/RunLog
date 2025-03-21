//
//  AppConfigRepositoryTests.swift
//  RunLogTests
//
//  Created by 김도연 on 3/19/25.
//

import XCTest
import CoreData
@testable import RunLog

final class AppConfigRepositoryTests: XCTestCase {
    
    var repository: AppConfigRepository?
    
    override func setUpWithError() throws {
        // ✅ In-Memory Store를 사용
        let container = TestCoreDataContainer()
        repository = AppConfigRepositoryImpl(context: container.context)
    }
    
    override func tearDownWithError() throws {
        repository = nil
    }
    
    /// ✅ `createAppConfig` & `readAppConfig` 테스트
    func test_createAndReadAppConfig() async throws {
        guard let repository = repository else {
            XCTFail("repository nil")
            return
        }
        
        // Given (테스트용 데이터 생성)
        let testConfig = AppConfig(nickname: "테스트 유저", totalDistance: 100.5, streakDays: 10, totalDays: 20, unitDistance: 1.5)
        
        // When (생성)
        try await repository.createAppConfig(testConfig)
        
        // Then (저장된 데이터가 일치하는지 확인)
        let savedConfig = try await repository.readAppConfig()
        
        XCTAssertEqual(savedConfig, testConfig)
    }
    
    /// ✅ `updateAppConfig` 테스트
    func test_updateAppConfig() async throws {
        guard let repository = repository else {
            XCTFail("repository nil")
            return
        }
        
        // Given (초기 데이터 저장)
        let initialConfig = AppConfig(nickname: "초기 설정", totalDistance: 50.0, streakDays: 5, totalDays: 10, unitDistance: 2.0)
        try await repository.createAppConfig(initialConfig)
        
        // When (업데이트 실행)
        let updatedConfig = AppConfig(nickname: "수정된 설정", totalDistance: 200.0, streakDays: 15, totalDays: 30, unitDistance: 3.5)
        try await repository.updateAppConfig(updatedConfig)
        
        // Then (업데이트된 데이터 검증)
        let savedConfig = try await repository.readAppConfig()
        XCTAssertEqual(savedConfig.nickname, "수정된 설정")
        XCTAssertEqual(savedConfig.totalDistance, 200.0)
        XCTAssertEqual(savedConfig.streakDays, 15)
        XCTAssertEqual(savedConfig.totalDays, 30)
        XCTAssertEqual(savedConfig.unitDistance, 3.5)
    }
    
    /// ✅ `deleteAppConfig` 테스트
    func test_deleteAppConfig() async throws {
        guard let repository = repository else {
            XCTFail("repository nil")
            return
        }
        
        // Given (초기 데이터 저장)
        let testConfig = AppConfig(nickname: "삭제할 설정", totalDistance: 75.3, streakDays: 7, totalDays: 14, unitDistance: 2.5)
        try await repository.createAppConfig(testConfig)
        
        // When (삭제 실행)
        try await repository.deleteAppConfig()
        
        // Then (삭제 후 데이터 조회 시 에러 발생 여부 확인)
        do {
            _ = try await repository.readAppConfig()
            XCTFail("❌ 삭제 후 데이터를 읽으면 안 됩니다.")
        } catch {
            XCTAssertTrue(error is AppConfigError, "❌ 삭제 후 예외(AppConfigError)가 발생해야 합니다.")
        }
    }
}


final class DayLogRepositoryTests: XCTestCase {
    
    var repository: DayLogRepository?
    
    override func setUpWithError() throws {
        let container = TestCoreDataContainer()
        repository = DayLogRepositoryImpl(context: container.context)
    }
    
    override func tearDownWithError() throws {
        repository = nil
    }
    
    func testRepository() async {
        guard let repository = repository else {
            XCTFail("nil")
            return
        }
        
        // Create & Read
        let dummyDayLog = DummyData.dummyDayLogs[0]
        try? await repository.createDayLog(dummyDayLog)
        let dayLog = try? await repository.readDayLog(date: dummyDayLog.date)
        
        XCTAssertEqual(dummyDayLog, dayLog)
        
        // ReadAll
        let dayLogs = try? await repository.readAllDayLogs()
        XCTAssertEqual(dummyDayLog, dayLogs![0])
        
        // Update & Read
        var updatedDayLog = dummyDayLog
        updatedDayLog.title = "목동"
        try? await repository.updateDayLog(updatedDayLog)
        let fetchDayLog = try? await repository.readDayLog(
            date: updatedDayLog.date
        )
        
        XCTAssertEqual(fetchDayLog, updatedDayLog)
        
        
        // Delete
        try? await repository.deleteDayLog(date: dummyDayLog.date)
        let emptyDayLogs = try? await repository.readAllDayLogs()
        
        XCTAssert(emptyDayLogs!.isEmpty)
    }
    
}
