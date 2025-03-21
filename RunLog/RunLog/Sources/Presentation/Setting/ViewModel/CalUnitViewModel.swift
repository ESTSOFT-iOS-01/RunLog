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
    
    struct Output {
        let unitUpdated = CurrentValueSubject<String, Never>("10.0")
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
                    self?.saveUnit()
                case .loadData:
                    self?.fetchUnitDistance()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .map { text in
                let locale = Locale.current
                let decimalSeparator = locale.decimalSeparator ?? "."
                
                let formattedText = text
                    .replacingOccurrences(of: decimalSeparator, with: ".")
                    .filter { $0.isNumber || $0 == "." } // 숫자와 .만 허용

                return formattedText // 그대로 String으로 처리
            }
            .sink { [weak self] value in
                self?.output.unitUpdated.send(value)
            }
            .store(in: &cancellables)
    }
    
    private func saveUnit() {
        Task {
            do {
                try await appConfigUseCase.updateUnitDistance(Double(output.unitUpdated.value) ?? 10.0)
                self.output.saveSuccess.send(true)
            } catch {
                print("Error saving UnitDistance : \(error)")
                self.output.saveSuccess.send(false)
            }
        }
    }
    
    private func fetchUnitDistance() {
        Task {
            do {
                let savedUnit = try await appConfigUseCase.getUnitDistance()
                self.output.unitUpdated.send(Double(savedUnit).formattedString)
            } catch {
                print("Error fetching unitDistance: \(error)")
            }
        }
    }
    
}
