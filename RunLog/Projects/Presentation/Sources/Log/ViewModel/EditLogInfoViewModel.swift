//
//  EditLogInfo.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//
import RLDomain
import RLInject

import UIKit
import Combine

final class EditLogInfoViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case loadData // 유저 데이터 호출
        case saveButtonTapped // 저장 버튼 클릭
        case logLevelSelected(Int) // 난이도 저장
    }
    
    struct Output {
        let logNameUpdated = CurrentValueSubject<String, Never>("기록 이름")
        let logLevelUpdated = CurrentValueSubject<Int, Never>(2)
        let saveSuccess = CurrentValueSubject<Bool, Never>(false)
    }
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>() // Input 스트림
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = Output()
    
    private(set) var date : Date?
    
    // MARK: - Init
    init(date: Date) {
        self.date = date
    }
    
    // MARK: - Bind (Input -> Output)
    func bind() {
        inputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .loadData:
                    self?.fetchLogInfo()
                case .saveButtonTapped:
                    self?.saveLogInfo()
                case .logLevelSelected(let index):
                    self?.output.logLevelUpdated.send(index)
                }
            }
            .store(in: &cancellables)
    }
    
    func bindTextField(_ textPublisher: AnyPublisher<String, Never>) {
        textPublisher
            .sink { [weak self] text in
                self?.output.logNameUpdated.send(text)
            }
            .store(in: &cancellables)
    }
    
    private func saveLogInfo() {
        guard let date = self.date else { return }
        Task {
            do {
                try await dayLogUseCase.updateTitleByDate(date, title: output.logNameUpdated.value)
                
                try await dayLogUseCase.updateLevelByDate(date, level: output.logLevelUpdated.value)
                
                self.output.saveSuccess.send(true)
            } catch {
                print("Error saving Info: \(error)")
                self.output.saveSuccess.send(false)
            }
        }
    }
    
    private func fetchLogInfo() {
        guard let date = self.date else { return }
        Task {
            do {
                let title = try await  dayLogUseCase.getTitleByDate(date)
                let level = try await dayLogUseCase.getLevelByDate(date)
                
                output.logNameUpdated.send(title)
                output.logLevelUpdated.send(level)
            }
        }
    }
    
}
