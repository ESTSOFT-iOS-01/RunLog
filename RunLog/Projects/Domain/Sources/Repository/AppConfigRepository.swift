//
//  AppConfigRepository.swift
//  RunLog
//
//  Created by 김도연 on 3/19/25.
//

import Foundation

/// 앱 설정(AppConfig)에 대한 CRUD 기능을 정의하는 저장소 프로토콜입니다.
/// 영속 저장소(UserDefaults, File, Database 등)와의 인터페이스를 추상화합니다.
public protocol AppConfigRepository {
    
    /// 앱 설정을 생성하여 저장소에 기록합니다.
    /// - Parameter config: 저장할 앱 설정 값
    func createAppConfig(_ config: AppConfig) async throws

    /// 저장소에 저장된 앱 설정을 읽어옵니다.
    /// - Returns: 저장된 앱 설정 값
    func readAppConfig() async throws -> AppConfig

    /// 기존 앱 설정을 업데이트합니다.
    /// - Parameter config: 업데이트할 앱 설정 값
    func updateAppConfig(_ config: AppConfig) async throws

    /// 저장된 앱 설정을 삭제합니다.
    func deleteAppConfig() async throws
}
