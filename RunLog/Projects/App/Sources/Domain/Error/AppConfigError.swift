//
//  AppConfigError.swift
//  RunLog
//
//  Created by 김도연 on 4/2/25.
//

import Foundation

/// AppConfig 저장소 동작 중 발생할 수 있는 에러를 정의한 열거형입니다.
enum AppConfigError: Error {
    
    /// 이미 AppConfig 객체가 존재하는 경우
    case duplicatedObject
    
    /// AppConfig 데이터를 찾을 수 없는 경우
    case notFound
    
    /// 디코딩 또는 인코딩 등 데이터 변환에 실패한 경우
    case dataConversionFailed
    
    /// AppConfig 데이터를 저장하는 데 실패한 경우
    case saveFailed
    
    /// AppConfig 데이터를 삭제하는 데 실패한 경우
    case deleteFailed

    /// 에러 설명 문자열 (로컬라이즈 가능)
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "AppConfig 데이터를 찾을 수 없습니다."
        case .dataConversionFailed:
            return "데이터 변환 중 오류가 발생했습니다."
        case .saveFailed:
            return "데이터 저장에 실패했습니다."
        case .deleteFailed:
            return "데이터 삭제에 실패했습니다."
        case .duplicatedObject:
            return "한 개 이상의 AppConfig 데이터가 이미 존재합니다."
        }
    }
}
