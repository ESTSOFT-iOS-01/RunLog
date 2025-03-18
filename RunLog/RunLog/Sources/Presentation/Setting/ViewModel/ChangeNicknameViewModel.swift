//
//  ChangeNicknameViewModel.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import Combine

final class ChangeNicknameViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case saveButtonTapped // 저장 버튼 클릭
    }
    
    enum Output {
        case nicknameUpdated(String) // UI에 반영할 닉네임
        case saveSuccess // 저장 완료 이벤트
    }
    
    @Published private(set) var nickname: String = "RunLogger" // 기본값
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>() // Input 스트림
    private let outputSubject = PassthroughSubject<Output, Never>() // Output 스트림
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    init() {
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        inputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .saveButtonTapped:
                    self?.saveNickname()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .sink { [weak self] text in
                self?.nickname = text
                self?.outputSubject.send(.nicknameUpdated(text))
            }
            .store(in: &cancellables)
    }
    
    private func saveNickname() {
        print("[Debug] 닉네임 저장됨: \(nickname)")
        outputSubject.send(.saveSuccess)
    }
}
