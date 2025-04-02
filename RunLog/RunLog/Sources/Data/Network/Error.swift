//
//  Error.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import Foundation

/// OpenWeather API에서 발생한 에러 응답 모델입니다.
struct OpenWeatherError : Codable {
    let cod : Int
    let message : String
}

/// 네트워크 요청 중 발생할 수 있는 에러를 정의한 열거형입니다.
enum NetworkError: Error {
    
    /// 3xx 리디렉션 오류
    case redirectionError
    
    /// 4xx 클라이언트 오류
    /// - Parameters:
    ///   - code: 상태 코드
    ///   - message: 오류 메시지
    case clientError(Int, String)
    
    /// 5xx 서버 오류
    /// - Parameters:
    ///   - code: 상태 코드
    ///   - message: 오류 메시지
    case serverError(Int, String)
    
    /// 디코딩 실패
    case decodingFailed
    
    /// 알 수 없는 오류
    case unknown
    
    /// 사용자에게 표시할 에러 메시지 문자열입니다.
    var errorMessage: String {
        switch self {
        case .redirectionError:
            return "리디렉션 오류 발생"
        case .clientError(let code, let message):
            return "클라이언트 오류 (\(code)): \(message)"
        case .serverError(let code, let message):
            return "서버 오류 (\(code)): \(message)"
        case .decodingFailed:
            return "데이터 변환 오류 : 데이터를 불러오는 중 문제가 발생했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
