//
//  ProfileCardType.swift
//  RunLog
//
//  Created by 김도연 on 4/2/25.
//

import UIKit

/// 카드 타입을 정의합니다. (운동 기록, 스트릭 등)
enum ProfileCardType {
    case logCount
    case streak

    /// 카드 제목
    var title: String {
        switch self {
        case .logCount: return "운동 기록"
        case .streak: return "연속 스트릭"
        }
    }

    /// 단위 텍스트
    var unit: String {
        switch self {
        case .logCount: return "건"
        case .streak: return "일"
        }
    }

    /// 시스템 아이콘 이름
    var iconName: String {
        switch self {
        case .logCount: return RLIcon.document.name
        case .streak: return RLIcon.streak.name
        }
    }
}

