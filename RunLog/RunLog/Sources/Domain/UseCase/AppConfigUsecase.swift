//
//  AppConfigUsecase.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//

import Foundation

protocol AppConfigUsecase {

    // MARK: - Fetch Methods
    
    /// 저장된 단위를 불러옵니다.
    ///
    /// - Returns: 현재 저장된 거리 단위 (km)
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 데이터 로딩 실패, 변환 실패 등
    func getUnitDistance() async throws -> Double
    
    /// 저장된 유저 닉네임을 불러옵니다.
    ///
    /// - Returns: 저장된 유저 닉네임
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 데이터 로딩 실패 등
    func getNickname() async throws -> String
    
    /// 유저의 연속 기록 일수와 총 기록 일수를 불러옵니다.
    ///
    /// - Returns: (연속 기록 일수, 총 기록 일수) 튜플
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 데이터 로딩 실패 등
    func getUserIndicators() async throws -> (streakDays: Int, totalDays: Int)
    
    /// 유저의 총 이동 거리를 불러옵니다.
    ///
    /// - Returns: 총 이동 거리 (km)
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 데이터 로딩 실패 등
    func getTotalDistance() async throws -> Double
    
    /// 유저의 거리 관련 지표를 불러옵니다.
    ///
    /// - Returns: 기준 길 이름과 횟수를 포함한 튜플
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 데이터 로딩 실패 등
    func getDistanceIndicators() async throws -> (roadName: String, count : Double)
    
    // MARK: - Save Methods
    
    /// 거리 단위를 저장합니다.
    ///
    /// - Parameter unitDistance: 새롭게 설정할 거리 단위 (km)
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 저장 실패 등
    func updateUnitDistance(_ unitDistance: Double) async throws
    
    /// 유저 닉네임을 저장합니다.
    ///
    /// - Parameter nickname: 새롭게 설정할 유저 닉네임
    /// - Throws: `AppConfigError`를 발생시킬 수 있습니다.
    ///           예: 저장 실패 등
    func updateNickname(_ nickname: String) async throws
    
}
