//
//  SettingModel.swift
//  RunLog
//
//  Created by 김도연 on 3/20/25.
//

import UIKit

enum SettingMenuType {
    case changeNickname
    case changeCalendarUnit
}

extension SettingMenuType: CaseIterable {
    var title : String {
        switch self {
        case .changeNickname:
            return "닉네임 변경"
        case .changeCalendarUnit:
            return "기록 시각화 단위 변경"
        }
    }
    
    var viewControllerType: UIViewController.Type {
        switch self {
        case .changeNickname:
            return ChangeNicknameViewController.self
        case .changeCalendarUnit:
            return ChangeCalUnitViewController.self
        }
    }
}

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
