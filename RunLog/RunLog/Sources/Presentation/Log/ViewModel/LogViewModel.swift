//
//  Log.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import Combine

final class LogViewModel {
    
    // MARK: - Input & Output
    enum Input {
    }
    
    enum Output {
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    private func bind() {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                    
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
}
