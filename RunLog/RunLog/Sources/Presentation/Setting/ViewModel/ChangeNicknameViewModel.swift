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
        case loadData // 유저 데이터 호출
        case saveButtonTapped // 저장 버튼 클릭
    }
    
    struct Output {
        let nicknameUpdated = CurrentValueSubject<String, Never>("RunLogger")
        let saveSuccess = CurrentValueSubject<Bool, Never>(false)
    }
    
    @Dependency private var appConfigUseCase: AppConfigUsecase
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>() // Input 스트림
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = .init()
    
    // MARK: - Init
    
    // MARK: - Bind (Input -> Output)
    func bind() {
        inputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .saveButtonTapped:
                    self?.saveNickname()
                case .loadData:
                    self?.fetchNickname()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .sink { [weak self] text in
                self?.output.nicknameUpdated.send(text)
            }
            .store(in: &cancellables)
    }
    
    private func saveNickname() {
        Task {
            do {
                try await appConfigUseCase.updateNickname(output.nicknameUpdated.value)

                self.output.saveSuccess.send(true)
            } catch {
                print("Error saving nickname: \(error)")
                self.output.saveSuccess.send(false)
            }
        }
    }
    
    private func fetchNickname() {
        Task {
            do {
                let savedNickname = try await appConfigUseCase.getNickname()
                self.output.nicknameUpdated.send(savedNickname)
            } catch {
                print("Error fetching nickname: \(error)")
            }
        }
    }
    
}
