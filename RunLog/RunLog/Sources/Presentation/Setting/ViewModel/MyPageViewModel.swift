//
//  MyPage.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import Combine

final class MyPageViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case loadData // 유저 데이터 호출
        case menuItemSelected(Int)
    }
    
    enum Output {
        case profileDataUpdated(UserInfoVO) // 유저 데이터 전달
        case navigateToViewController(UIViewController)
    }
    
    private let appConfigUseCase : AppConfigUsecaseImpl
    private let menuItems: [SettingMenuType] = SettingMenuType.allCases
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    private let outputSubject = PassthroughSubject<Output, Never>()

    var input: PassthroughSubject<Input, Never> { inputSubject }
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    init(appConfigUseCase: AppConfigUsecaseImpl) {
        self.appConfigUseCase = appConfigUseCase
        bind()
    }
    
    private func bind() {
        inputSubject
            .sink { [weak self] event in
                switch event {
                case .loadData:
                    self?.fetchProfileData()
                case .menuItemSelected(let index):
                    let selectedItem = self?.menuItems[index]
                    if let viewControllerType = selectedItem?.viewControllerType {
                        let viewController = viewControllerType.init()
                        self?.outputSubject.send(.navigateToViewController(viewController))
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func numberOfMenuItems() -> Int {
        return menuItems.count
    }

    func menuItem(at index: Int) -> SettingMenuType {
        return menuItems[index]
    }
    
    // MARK: - private Functions
    private func fetchProfileData() {
        Task {
            do {
                var userInfo = UserInfoVO(nickname: "RunLogger", totalDistance: 0.0, streakCount: 0, logCount: 0)
                userInfo.nickname = try await appConfigUseCase.getNickname()
                userInfo.totalDistance = try await appConfigUseCase.getTotalDistance()
                (userInfo.streakCount, userInfo.logCount) = try await appConfigUseCase.getUserIndicators()
                
                outputSubject.send(.profileDataUpdated(userInfo))
            } catch {
                print("usecase error : \(error)")
            }
            
        }
    }
}
