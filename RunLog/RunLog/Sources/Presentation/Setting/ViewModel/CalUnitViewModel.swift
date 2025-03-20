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
        case loadData // 유저 데이터 호출
        case saveButtonTapped
    }
    
    enum Output {
        case unitUpdated(Double)
        case saveSuccess
    }
    
    private let appConfigUseCase : AppConfigUsecaseImpl
    @Published private(set) var unit: Double = 10.0 // 기본값
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>() // Input 스트림
    private let outputSubject = PassthroughSubject<Output, Never>() // Output 스트림
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    var output: AnyPublisher<Output, Never> { outputSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    init(appConfigUseCase: AppConfigUsecaseImpl) {
        self.appConfigUseCase = appConfigUseCase
        
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
                case .loadData:
                    self?.fetchUnitDistance()
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
        Task {
            do {
                try await appConfigUseCase.updateUnitDistance(unit)
                outputSubject.send(.saveSuccess)
            } catch {
                print("Error saving UnitDistance : \(error)")
            }
        }
    }
    
    private func fetchUnitDistance() {
        Task {
            do {
                let savedUnit = try await appConfigUseCase.getUnitDistance()
                self.unit = savedUnit
                outputSubject.send(.unitUpdated(savedUnit))
            } catch {
                print("Error fetching unitDistance: \(error)")
            }
        }
    }
    
}
