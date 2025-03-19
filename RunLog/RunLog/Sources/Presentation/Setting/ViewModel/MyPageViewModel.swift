//
//  MyPage.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import Combine

enum SettingMenuType {
    case changeNickname
    case changeCalendarUnit
}

extension SettingMenuType: CaseIterable {
    var title : String {
        switch self {
        case .changeNickname:
            return "닉네임 변경"
        case .changeCalendarUnit:
            return "기록 시각화 단위 변경"
        }
    }
    
    var viewControllerType: UIViewController.Type {
        switch self {
        case .changeNickname:
            return ChangeNicknameViewController.self
        case .changeCalendarUnit:
            return ChangeCalUnitViewController.self
        }
    }
}

final class MyPageViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case loadData
        case menuItemSelected(Int)
    }
    
    enum Output {
        case profileDataUpdated(AppConfig)
        case navigateToViewController(UIViewController)
    }
    
    // TODO : repository 구현하면 data read해서 사용.
    private var appConfig = AppConfig(
        nickname: "뷰모델테스터",
        totalDistance: 1234,
        streakDays: 12,
        totalDays: 94,
        unitDistance: 10.1
    )
    
    private let menuItems: [SettingMenuType] = SettingMenuType.allCases
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    private let outputSubject = PassthroughSubject<Output, Never>()

    var input: PassthroughSubject<Input, Never> { inputSubject }
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    init() {
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
        // TODO: - repository 구현하면 data read해서 사용.
        outputSubject.send(.profileDataUpdated(appConfig))
    }
}
