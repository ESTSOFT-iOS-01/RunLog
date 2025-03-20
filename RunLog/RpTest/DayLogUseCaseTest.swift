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
        let container = TestCoreDataContainer()
        let repository = DayLogRepositoryImpl(context: container.context)
        dayLogUseCase = DayLogUseCaseImpl(dayLogRepository: repository)
    }
    
    override func tearDownWithError() throws {
        dayLogUseCase = nil
    }
    
    func testAddSection() async {
        guard let dayLogUseCase = dayLogUseCase else {
            XCTFail("usecase nil")
            return
        }
        
        let today = Date().formatted
        let point = Point(latitude: 1.0, longitude: 1.0, timestamp: Date())
        let section = Section(distance: 0.0, steps: 1, route: [point])
        
        try? await dayLogUseCase.initializeDayLog(
            locationName: "서울",
            weather: 1,
            temperature: 1
        )
        
        let fetchedDayLog1 = try? await dayLogUseCase.getDayLogByDate(today)
        print(fetchedDayLog1!)
        
        
        try? await dayLogUseCase.addSectionByDate(today, section: section)
        
        let fetchedDayLog2 = try? await dayLogUseCase.getDayLogByDate(today)
        print(fetchedDayLog2!)
    }
}
