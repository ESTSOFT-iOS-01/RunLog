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
        case loadData             // 저장된 단위 거리 불러오기
        case saveButtonTapped     // 저장 버튼 클릭
    }
    
    struct Output {
        /// 현재 입력된 거리 단위 문자열
        let unitUpdated = CurrentValueSubject<String, Never>("10.0")
        
        /// 저장 성공 여부
        let saveSuccess = CurrentValueSubject<Bool, Never>(false)
    }

    @Dependency private var appConfigUseCase: AppConfigUseCase
    
    private var cancellables = Set<AnyCancellable>()
    private let inputSubject = PassthroughSubject<Input, Never>()
    
    var input: PassthroughSubject<Input, Never> { inputSubject }
    private(set) var output: Output = .init()
    
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
    
    /// 텍스트 필드 입력을 받아 유효한 거리 단위 문자열로 정리합니다.
    /// 소수 구분자는 현재 로케일에 맞춰 처리합니다.
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
    
    /// 입력된 거리 단위를 저장소에 저장합니다.
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
    
    /// 저장된 거리 단위를 불러와 출력 스트림에 반영합니다.
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
