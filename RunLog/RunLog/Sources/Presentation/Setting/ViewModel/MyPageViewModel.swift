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
        case loadData              // 유저 데이터 호출
        case menuItemSelected(Int) // 메뉴 항목 선택
    }
    
    struct Output {
        let stopLoading = CurrentValueSubject<Bool, Never>(false)
        let profileDataUpdated = CurrentValueSubject<UserInfoVO, Never>(
            UserInfoVO(nickname: "RunLogger", totalDistance: 0.0, streakCount: 0, logCount: 0)
        )
        let navigateToViewController = CurrentValueSubject<UIViewController?, Never>(nil)
    }
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    private let menuItems: [SettingMenuType] = SettingMenuType.allCases
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = Output()

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
            output.stopLoading.send(false)

            do {
                try await dayLogUseCase.updateStreakIfNeeded()

                var userInfo = UserInfoVO(nickname: "RunLogger", totalDistance: 0.0, streakCount: 0, logCount: 0)
                userInfo.nickname = try await appConfigUseCase.getNickname()
                userInfo.totalDistance = try await appConfigUseCase.getTotalDistance()
                (userInfo.streakCount, userInfo.logCount) = try await appConfigUseCase.getUserIndicators()

                output.profileDataUpdated.send(userInfo)
            } catch {
                print("UseCase error: \(error)")
            }

            output.stopLoading.send(true)
        }
    }
    
    private func handleMenuSelection(_ index: Int) {
        guard menuItems.indices.contains(index) else { return }
        let selectedItem = menuItems[index]
        let viewController = createViewController(for: selectedItem)
        output.navigateToViewController.send(viewController)
    }

    private func createViewController(for selectedItem: SettingMenuType) -> UIViewController {
        switch selectedItem {
        case .changeCalendarUnit:
            return ChangeCalUnitViewController(viewModel: CalUnitViewModel())
        case .changeNickname:
            return ChangeNicknameViewController(viewModel: ChangeNicknameViewModel())
        }
    }
    
}
