//
//  Error.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import Foundation

/// 네트워크 에러 정의 - 이거는 약간 임시에요,,, 실제 서버 에러 핸들링 보면서 자세한 에러문 출력도 해야함
enum NetworkError: Error {
    case redirectionError
    case clientError(Int) // 400번대 에러
    case serverError(Int) // 500번대 에러
    case decodingFailed   // JSON 디코딩 실패
    case unknown          // 알 수 없는 에러
    
    /// 사용자 친화적인 에러 메시지 반환
    var errorMessage: String {
        switch self {
        case .redirectionError:
            return "다른 URL로 리디렉션되었습니다."
        case .clientError(let code):
            return "클라이언트 오류 발생 (\(code)). 요청을 확인해주세요."
        case .serverError(let code):
            return "서버 오류 발생 (\(code)). 잠시 후 다시 시도해주세요."
        case .decodingFailed:
            return "데이터를 불러오는 중 문제가 발생했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
