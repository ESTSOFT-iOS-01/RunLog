//
//  Running.swift
//  RunLog
//
//  Created by 심근웅 on 3/17/25.
//

import UIKit
import Combine

struct SectionRecord {
    var sectionTime: TimeInterval // 시간
    var distance: Double // 거리
    var steps: Int // 걸음 수
}

final class RunningViewModel {
    
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
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                    
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - private Functions
}
