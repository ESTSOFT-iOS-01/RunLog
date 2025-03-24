//
//  Error.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import Foundation

struct OpenWeatherError : Codable {
    let cod : Int
    let message : String
}

enum NetworkError: Error {
    case redirectionError // 리디렉션 에러
    case clientError(Int, String) // 클라이언트 에러
    case serverError(Int, String) // 서버 에러
    case decodingFailed   // 디코딩 실패
    case unknown  // 알 수 없는 에러
    
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
