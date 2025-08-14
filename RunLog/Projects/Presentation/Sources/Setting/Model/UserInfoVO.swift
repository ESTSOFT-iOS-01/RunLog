//
//  UserInfoVO.swift
//  RunLog
//
//  Created by 김도연 on 4/2/25.
//
import RLUtil

import Foundation

/// 사용자 정보를 담는 ViewObject
struct UserInfoVO {
    var nickname: String
    var totalDistance: Double
    var streakCount: Int
    var logCount: Int

    init(nickname: String, totalDistance: Double, streakCount: Int, logCount: Int) {
        self.nickname = nickname
        self.totalDistance = totalDistance
        self.streakCount = streakCount
        self.logCount = logCount
    }
}

extension UserInfoVO {
    /// "홍길동 님" 형태로 변환된 닉네임
    var displayNickname: String {
        return "\(nickname) 님"
    }

    /// "25.3km" 형태로 변환된 총 이동 거리
    var formattedTotalDistance: String {
        return totalDistance.toString(withDecimal: 1) + "km"
    }

    /// "지금까지 총 xx.xkm를 걸으셨어요!" 형태의 문장 전체
    var summaryMessage: String {
        return "지금까지 총 \(formattedTotalDistance)를 걸으셨어요!"
    }
}
