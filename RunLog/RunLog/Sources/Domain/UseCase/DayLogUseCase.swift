//
//  DayLogUseCase.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import Foundation
import UIKit

protocol DayLogUseCase {
    
    /// 새로운 DayLog를 생성합니다. (러닝 시작 시 호출)
    /// - Parameters:
    ///   - locationName: 운동 위치 이름
    ///   - weather: 날씨 정보 (정수값)
    ///   - temperature: 기온 정보
    func initializeDayLog(
        locationName: String,
        weather: Int,
        temperature: Double
    ) async throws
    
    /// 특정 날짜의 DayLog를 조회합니다.
    /// - Parameter date: 조회할 날짜
    /// - Returns: 해당 날짜의 `DayLog`
    func getDayLogByDate(_ date: Date) async throws -> DayLog?
    
    /// 저장된 모든 DayLog를 조회합니다.
    /// - Returns: `DayLog` 배열
    func getAllDayLogs() async throws -> [DayLog]
    
    /// 특정 날짜의 DayLog를 삭제합니다.
    /// - Parameter date: 삭제할 날짜
    func deleteDayLogByDate(_ date: Date) async throws
    
    /// 특정 날짜의 DayLog에 새로운 섹션을 추가합니다.
    /// - Parameters:
    ///   - date: 섹션을 추가할 DayLog의 날짜
    ///   - section: 추가할 `Section`
    func addSectionByDate(_ date: Date, section: Section) async throws
    
    /// 특정 날짜의 DayLog에서 운동 제목을 조회합니다.
    /// - Parameter date: 조회할 날짜
    /// - Returns: 운동 제목 (`title`)
    func getTitleByDate(_ date: Date) async throws -> String
    
    /// 특정 날짜의 DayLog에서 운동 제목을 업데이트 합니다.
    /// - Parameters:
    ///   - date: 수정할 날짜
    ///   - title: 새로 수정할 운동 제목
    func updateTitleByDate(_ date: Date, title: String) async throws
    
    /// 특정 날짜의 DayLog에서 난이도를 조회합니다.
    /// - Parameter date: 조회할 날짜
    /// - Returns: 난이도 (`level`)
    func getLevelByDate(_ date: Date) async throws -> Int
    
    /// 특정 날짜의 DayLog에서 난이도를 업데이트 합니다.
    /// - Parameters:
    ///   - date: 수정할 날짜
    ///   - level: 새로 수정할 난이도 값
    func updateLevelByDate(_ date: Date, level: Int) async throws
    
    /// 특정 날짜의 DayLog에서 트랙 이미지를 수정합니다.
    /// - Parameters:
    ///   - date: 수정할 날짜
    ///   - image: 새로 수정할 트랙 이미지 (`UIImage`)
    func updateTrackImageByDate(_ date: Date, image: UIImage) async throws
    
    /// 운동 streak(연속 달성 여부)를 업데이트합니다.
    func updateStreakIfNeeded() async throws
    
}




