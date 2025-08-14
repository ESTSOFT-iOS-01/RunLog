//
//  NetworkProtocol.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

/// 네트워크 요청을 위한 기본 프로토콜입니다.
protocol NetworkService {
    associatedtype Endpoint: TargetType

    /// 요청을 보낼 때 사용되는 MoyaProvider
    var provider: MoyaProvider<Endpoint> { get }
}

/// 네트워크 요청을 실행하는 기본 구현입니다.
/// Combine의 `Publisher`를 통해 비동기 흐름을 처리합니다.
extension NetworkService {
    
    /// 네트워크 요청을 실행하고 응답을 디코딩합니다.
    /// - Parameters:
    ///   - target: 요청할 엔드포인트
    ///   - responseType: 디코딩할 모델 타입
    /// - Returns: 디코딩된 객체를 방출하는 Publisher
    func request<T: Decodable>(_ target: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        return provider.requestPublisher(target)
            .tryMap { response in
                // HTTP 상태 코드가 정상 범위인지 확인
                if !(200...299).contains(response.statusCode) {
                    let error = try self.parseError(from: response.data)
                    throw handleError(error.cod, message: error.message)
                }
                
                do {
                    return try JSONDecoder().decode(T.self, from: response.data)
                } catch {
                    throw NetworkError.decodingFailed
                }
            }
            .mapError { error in
                return error as? NetworkError ?? .unknown
            }
            .eraseToAnyPublisher()
    }
    
    /// HTTP 상태 코드에 따라 적절한 네트워크 에러로 변환합니다.
    /// - Parameters:
    ///   - statusCode: HTTP 상태 코드
    ///   - message: 서버에서 받은 에러 메시지
    /// - Returns: 대응되는 NetworkError
    private func handleError(_ statusCode: Int, message: String) -> NetworkError {
        switch statusCode {
        case 300..<400:
            return .redirectionError
        case 400..<500:
            return .clientError(statusCode, message)
        case 500..<600:
            return .serverError(statusCode, message)
        default:
            return .unknown
        }
    }
    
    /// 서버에서 받은 에러 응답을 디코딩합니다.
    /// - Parameter data: 서버의 응답 데이터
    /// - Returns: 디코딩된 OpenWeatherError 객체
    private func parseError(from data: Data) throws -> OpenWeatherError {
        do {
            let errorResponse = try JSONDecoder().decode(OpenWeatherError.self, from: data)
            return errorResponse
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
