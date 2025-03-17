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
    }
    
    enum Output {
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
//        input
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] event in
//                switch event {
//                    
//                }
//            }
//            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
}
