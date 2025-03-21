//
//  DoubleTest.swift
//  RpTest
//
//  Created by 김도연 on 3/20/25.
//

import XCTest
@testable import RunLog

final class DoubleTest: XCTestCase {

    // 필수적인 테스트 메서드만 작성
    func testFormattedStringWithTrailingZeroes() {
        let value: Double = 30.00028800
        XCTAssertEqual(value.formattedString, "30.000288")
    }

    func testFormattedStringWithWholeNumber() {
        let value: Double = 20.0
        XCTAssertEqual(value.formattedString, "20")
    }

    func testFormattedStringWithDecimal() {
        let value: Double = 20.30
        XCTAssertEqual(value.formattedString, "20.3")
    }
    
    func testFormattedStringWithZero() {
        let value: Double = 0.0
        XCTAssertEqual(value.formattedString, "0")
    }

    // 성능 테스트
    func testPerformanceExample() throws {
        self.measure {
            let _ = 123456.789.formattedString
        }
    }

}
