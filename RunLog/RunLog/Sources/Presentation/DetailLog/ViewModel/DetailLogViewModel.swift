//
//  DetailLogViewModel.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import Combine

final class DetailLogViewModel {
    
    // MARK: - Input & Output
    enum Input {
        case menuSelected(String)
    }
    
    enum Output {
        case loadedDayLog(DayLog)
        case edit
        case share
        case delete
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    
    private var cancellables = Set<AnyCancellable>()
    
    @Dependency private var dayLogUseCase: DayLogUseCase
    
    // MARK: - Init
    init(date: Date) {
        bind()
        loadTargetDayLog(date: date)
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .menuSelected(let title):
                    switch title {
                    case "수정하기":
                        self.output.send(.edit)
                    case "공유하기":
                        self.output.send(.share)
                    case "삭제하기":
                        self.output.send(.delete)
                    default:
                        break
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
    private func loadTargetDayLog(date: Date) {
        Task {
            guard let dayLog = try await dayLogUseCase.getDayLogByDate(date)
            else { return }
            output.send(.loadedDayLog(dayLog))
        }
    }
}
