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
        case edit
        case share
        case delete
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    
    private let date: Date
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(date: Date) {
        self.date = date
        print(date)
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input
            .receive(on: DispatchQueue.main)
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
}
