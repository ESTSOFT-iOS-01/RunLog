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

/// 네트워크 요청을 위한 기본 프로토콜
protocol NetworkService {
    associatedtype Endpoint: TargetType
    var provider: MoyaProvider<Endpoint> { get }

}

/// 네트워크 요청을 실행하는 기본 구현
extension NetworkService {
    func request<T: Decodable>(_ target: Endpoint, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        return provider.requestPublisher(target)
            .tryMap { response in
                if !(200...299).contains(response.statusCode) {
                    throw self.handleError(response.statusCode)
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
    
    /// HTTP 상태 코드에 따른 에러 처리
    private func handleError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 300..<400:
            return .redirectionError
        case 400..<500:
            return .clientError(statusCode)
        case 500..<600:
            return .serverError(statusCode)
        default:
            return .unknown
        }
    }
}
