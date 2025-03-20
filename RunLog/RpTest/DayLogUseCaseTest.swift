//
//  DayLogUseCaseTest.swift
//  RunLogTests
//
//  Created by 김도연 on 3/19/25.
//

import XCTest
import CoreData
@testable import RunLog

final class DayLogUseCaseTest: XCTestCase {
    
    var dayLogUseCase: DayLogUseCase?
    
    override func setUpWithError() throws {
        // ✅ In-Memory Store를 사용
        let container = TestCoreDataContainer()
        let repository = DayLogRepositoryImpl(context: container.context)
    }
    
    override func tearDownWithError() throws {
        dayLogUseCase = nil
    }
    
    
}
