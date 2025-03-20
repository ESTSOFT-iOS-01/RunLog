import XCTest
import Combine
import CoreLocation
@testable import RunLog

final class RunningTests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false // 실패 시 다음 테스트 실행 X
        app = XCUIApplication()
        app.launch() // ✅ 앱 실행
        
        // ✅ "운동 시작하기" 버튼 자동 클릭
        let startButton = app.buttons["운동 시작하기"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 5), "🚨 시작 버튼이 존재하지 않음")
        startButton.tap()
        
        // ✅ 화면 전환 확인 (운동 시간 라벨 체크)
        let timeLabel = app.staticTexts["운동 시간"]
        XCTAssertTrue(timeLabel.waitForExistence(timeout: 5), "🚨 운동 화면이 표시되지 않음")
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // ✅ 이후의 테스트는 운동 화면에서 진행 가능!
    func testRunningScreenUI() throws {
        let stepLabel = app.staticTexts["걸음 수"]
        XCTAssertTrue(stepLabel.exists, "🚨 걸음 수 라벨 없음")
    }
}
