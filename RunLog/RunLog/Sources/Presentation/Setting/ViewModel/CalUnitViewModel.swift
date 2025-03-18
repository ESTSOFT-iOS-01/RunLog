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
        case saveButtonTapped
    }
    
    enum Output {
        case unitUpdated(Double)
        case saveSuccess
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
                switch event {
                case .saveButtonTapped:
                    self?.saveUnit()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .map { Double($0) ?? 0.0 }
            .sink { [weak self] value in
                self?.unit = value
                self?.outputSubject.send(.unitUpdated(value))
            }
            .store(in: &cancellables)
    }
    
    private func saveUnit() {
        print("[Debug] 단위 저장됨: \(unit) km")
        outputSubject.send(.saveSuccess)
    }
    
}
