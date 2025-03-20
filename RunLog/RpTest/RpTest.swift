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
    
    var persistentContainer: NSPersistentContainer!
    var repository: AppConfigRepositoryImpl!

    override func setUpWithError() throws {
        // ✅ In-Memory Store를 사용
        persistentContainer = NSPersistentContainer(name: "DTOs")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("테스트용 Core Data 로딩 실패: \(error)")
            }
        }
        
        repository = AppConfigRepositoryImpl(context: persistentContainer.viewContext)
    }

    override func tearDownWithError() throws {
        repository = nil
        persistentContainer = nil
    }

    /// ✅ `createAppConfig` & `readAppConfig` 테스트
    func test_createAndReadAppConfig() async throws {
        // Given (테스트용 데이터 생성)
        let testConfig = AppConfig(nickname: "테스트 유저", totalDistance: 100.5, streakDays: 10, totalDays: 20, unitDistance: 1.5)
        
        // When (생성)
        try await repository.createAppConfig(testConfig)
        
        // Then (저장된 데이터가 일치하는지 확인)
        let savedConfig = try await repository.readAppConfig()
        
        XCTAssertEqual(savedConfig.nickname, "테스트 유저")
        XCTAssertEqual(savedConfig.totalDistance, 100.5)
        XCTAssertEqual(savedConfig.streakDays, 10)
        XCTAssertEqual(savedConfig.totalDays, 20)
        XCTAssertEqual(savedConfig.unitDistance, 1.5)
    }
    
    /// ✅ `updateAppConfig` 테스트
    func test_updateAppConfig() async throws {
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
