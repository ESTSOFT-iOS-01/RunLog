//
//  SettingMenuType.swift
//  RunLog
//
//  Created by 김도연 on 4/2/25.
//

import UIKit

/// 설정 메뉴 항목 정의
enum SettingMenuType: CaseIterable {
    case changeNickname
    case changeCalendarUnit

    /// 메뉴 타이틀
    var title: String {
        switch self {
        case .changeNickname: return "닉네임 변경"
        case .changeCalendarUnit: return "기록 시각화 단위 변경"
        }
    }

    /// 해당 메뉴가 이동할 ViewController 타입
    var viewControllerType: UIViewController.Type {
        switch self {
        case .changeNickname:
            return ChangeNicknameViewController.self
        case .changeCalendarUnit:
            return ChangeCalUnitViewController.self
        }
    }
}
