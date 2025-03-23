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
    
    struct Output {
        let profileDataUpdated = CurrentValueSubject<UserInfoVO, Never>(UserInfoVO(nickname: "RunLogger", totalDistance: 0.0, streakCount: 0, logCount: 0))
        let navigateToViewController = CurrentValueSubject<UIViewController?, Never>(nil)
    }
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    private let menuItems: [SettingMenuType] = SettingMenuType.allCases
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = Output()

    // MARK: - Init
    
    // MARK: - Bind (Input -> Output)
    func bind() {
        inputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadData:
                    self?.fetchProfileData()
                case .menuItemSelected(let index):
                    self?.handleMenuSelection(index)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
    private func fetchProfileData() {
        Task {
            do {
                var userInfo = UserInfoVO(nickname: "RunLogger", totalDistance: 0.0, streakCount: 0, logCount: 0)
                try await dayLogUseCase.updateStreakIfNeeded()
                
                userInfo.nickname = try await appConfigUseCase.getNickname()
                userInfo.totalDistance = try await appConfigUseCase.getTotalDistance()
                (userInfo.streakCount, userInfo.logCount) = try await appConfigUseCase.getUserIndicators()
                
                output.profileDataUpdated.send(userInfo)
            } catch {
                print("usecase error : \(error)")
            }
        }
    }
    
    private func handleMenuSelection(_ index: Int) {
        let selectedItem = menuItems[index]
        
        let viewController = createViewController(for: selectedItem)
        output.navigateToViewController.send(viewController)
    }
    
    private func createViewController(for selectedItem: SettingMenuType) -> UIViewController {
        switch selectedItem {
        case .changeCalendarUnit:
            let viewModel = CalUnitViewModel()
            return ChangeCalUnitViewController(viewModel: viewModel)
        case .changeNickname:
            let viewModel = ChangeNicknameViewModel()
            return ChangeNicknameViewController(viewModel: viewModel)
        }
    }
    
}
