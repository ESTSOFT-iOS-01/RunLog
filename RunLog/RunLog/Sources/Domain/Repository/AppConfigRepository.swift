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
