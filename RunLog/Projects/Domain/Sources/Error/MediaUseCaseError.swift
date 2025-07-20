//
//  MediaUseCaseError.swift
//  RunLog
//
//  Created by 김도연 on 4/2/25.
//

import Foundation

/// MediaUseCase 수행 중 발생할 수 있는 에러 유형입니다.
enum MediaUseCaseError: Error {
    /// 스냅샷 이미지 생성에 실패한 경우
    case snapshotFailed
    /// 중심 좌표가 설정되지 않은 경우
    case noCenterPos
}

extension MediaUseCaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .snapshotFailed:
            return "스냅샷 생성에 실패하였습니다."
        case .noCenterPos:
            return "중심 좌표가 없습니다."
        }
    }
}
