//
//  CalUnitViewModel.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import Combine

final class CalUnitViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case unitChanged(String) // 사용자가 입력값 변경
        case saveButtonTapped // 저장 버튼 클릭
    }
    
    enum Output {
        case unitUpdated(Double) // UI에 반영할 단위 값
        case saveSuccess // 저장 완료 이벤트
    }
    
    @Published private(set) var unit: Double = 10.0 // 기본값
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
                guard let self = self else { return }
                switch event {
                case .unitChanged(let text):
                    self.validateAndUpdateUnit(text)
                    
                case .saveButtonTapped:
                    self.saveUnit()
                }
            }
            .store(in: &cancellables)
    }
    
    private func validateAndUpdateUnit(_ text: String) {
        if let value = Double(text), value <= 100, value != unit {
            unit = value
            outputSubject.send(.unitUpdated(value))
        }
    }
    
    private func saveUnit() {
        print("[Debug] 시각화 단위 저장됨: \(unit) km")
        outputSubject.send(.saveSuccess)
    }
}
