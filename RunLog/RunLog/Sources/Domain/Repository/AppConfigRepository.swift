//
//  AppConfigRepository.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//

import Foundation

protocol AppConfigRepository {    
    func createAppConfig(_ config: AppConfig) async throws
    func readAppConfig() async throws -> AppConfig
    func updateAppConfig(_ config: AppConfig) async throws
    func deleteAppConfig() async throws
}


/// 에러 
enum AppConfigError: Error {
    case notFound
    case dataConversionFailed
    case saveFailed
    case deleteFailed

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
        }
    }
}
