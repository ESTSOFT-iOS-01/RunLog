//
//  EditLogInfo.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import UIKit
import Combine

final class EditLogInfoViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case saveButtonTapped // 저장 버튼 클릭
        case logLevelSelected(Int) // 난이도 저장
        case logNameChanged(String) // 로그 네임 변경
    }
    
    enum Output {
        case logNameUpdated(String)
        case logLevelUpdated(Int)
        case saveSuccess // 저장 완료 이벤트
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>() // Input 스트림
    private let outputSubject = PassthroughSubject<Output, Never>() // Output 스트림
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    let items = ["매우 쉬움", "쉬움", "보통", "어려움", "매우 어려움"]

    private(set) var selectedIndex: Int = 2
    private(set) var logName: String = "화요일 오후 산책" // 기록 이름
    
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
                    self?.saveLogInfo()
                case .logLevelSelected(let index):
                    self?.selectedIndex = index
                    self?.outputSubject.send(.logLevelUpdated(index))
                case .logNameChanged(let name):
                    self?.logName = name
                    self?.outputSubject.send(.logNameUpdated(name))
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .removeDuplicates()
            .sink { [weak self] text in
                self?.inputSubject.send(.logNameChanged(text))
            }
            .store(in: &cancellables)
    }
    
    private func saveLogInfo() {
        // 저장 로직 (예: CoreData, UserDefaults)
        print("[Debug] 로그 저장됨: 이름=\(logName), 난이도=\(selectedIndex)")
        outputSubject.send(.saveSuccess)
    }
    
}
