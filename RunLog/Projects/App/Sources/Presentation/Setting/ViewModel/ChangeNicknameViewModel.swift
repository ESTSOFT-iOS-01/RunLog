//
//  ChangeNicknameViewModel.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//
import RLDomain

import UIKit
import Combine

final class ChangeNicknameViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case loadData            // 저장된 닉네임 불러오기
        case saveButtonTapped    // 저장 버튼 클릭
    }
    
    struct Output {
        /// 현재 입력된 닉네임 상태
        let nicknameUpdated = CurrentValueSubject<String, Never>("RunLogger")
        
        /// 저장 성공 여부
        let saveSuccess = CurrentValueSubject<Bool, Never>(false)
    }
    
    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = .init()
    
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
    
    /// 텍스트 필드 입력값을 nicknameUpdated에 실시간 반영합니다.
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .sink { [weak self] text in
                self?.output.nicknameUpdated.send(text)
            }
            .store(in: &cancellables)
    }
    
    /// 현재 입력된 닉네임을 저장소에 업데이트합니다.
    private func saveNickname() {
        Task {
            do {
                try await appConfigUseCase.updateNickname(output.nicknameUpdated.value)
                output.saveSuccess.send(true)
            } catch {
                print("Error saving nickname: \(error)")
                output.saveSuccess.send(false)
            }
        }
    }
    
    /// 저장된 닉네임을 불러와 nicknameUpdated에 반영합니다.
    private func fetchNickname() {
        Task {
            do {
                let savedNickname = try await appConfigUseCase.getNickname()
                output.nicknameUpdated.send(savedNickname)
            } catch {
                print("Error fetching nickname: \(error)")
            }
        }
    }
    
}
