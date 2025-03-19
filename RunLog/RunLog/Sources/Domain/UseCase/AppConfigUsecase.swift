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
    func getUnitDistance() -> Double
    
    /// 저장된 유저 닉네임을 불러옵니다.
    ///
    /// - Returns: 저장된 유저 닉네임
    func getNickname() -> String
    
    /// 유저의 연속 기록 일수와 총 기록 일수를 불러옵니다.
    ///
    /// - Returns: (연속 기록 일수, 총 기록 일수) 튜플
    func getUserIndicators() -> (streakDays: Int, totalDays: Int)
    
    /// 유저의 총 이동 거리를 불러옵니다.
    ///
    /// - Returns: 총 이동 거리 (km)
    func getTotalDistance() -> Double
    
    // MARK: - Save Methods
    
    /// 거리 단위를 저장합니다.
    ///
    /// - Parameter unitDistance: 새롭게 설정할 거리 단위 (km)
    func updateUnitDistance(_ unitDistance: Double)
    
    /// 유저 닉네임을 저장합니다.
    ///
    /// - Parameter nickname: 새롭게 설정할 유저 닉네임
    func updateNickname(_ nickname: String)
    
}
