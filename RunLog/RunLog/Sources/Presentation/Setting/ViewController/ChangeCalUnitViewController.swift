//
//  ChangeCalUnitViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class ChangeCalUnitViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CalUnitViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private lazy var calUnitView = CalUnitView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTextField()
        setupGesture()
        setupData()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        view.backgroundColor = .Gray900
        view.addSubview(calUnitView)
        
        calUnitView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview().offset(130)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        navigationItem.title = "기록 시각화 단위 설정"
        self.navigationController?.setupAppearance()
        
        navigationController?
            .addRightButton(title: "완료")
            .sink { [weak self] in
                self?.validateAndSaveUnit()
            }
            .store(in: &cancellables)
    }
    

    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
        setupTapGestureToDismissKeyboard()
    }
    
    private func setupTextField() {
        calUnitView.unitField.delegate = self
    }
    
    // MARK: - Setup Data
    private func setupData() {
        if viewModel.unit != 0 {
            calUnitView.unitField.setTextWithUnderline(String(viewModel.unit))
        }
        calUnitView.updateDescriptionText(with: viewModel.unit)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.bindTextField(calUnitView.unitField.publisher)
        
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .saveSuccess:
                    self?.navigationController?.popViewController(animated: true)
                case .unitUpdated(let value):
                    self?.calUnitView.updateDescriptionText(with: value)
                }
            }
            .store(in: &cancellables)
    }
    
    private func validateAndSaveUnit() {
        guard let text = calUnitView.unitField.text, let value = Double(text), value > 0 else {
            showAlert(message: "올바른 값을 입력해주세요.")
            return
        }
        viewModel.input.send(.saveButtonTapped)
    }

}

extension ChangeCalUnitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)

        if updatedText.filter({ $0 == "." }).count > 1 {
            return false
        }
        
        if let value = Double(updatedText), value > 100 {
            return false
        }
        
        if let currentText = textField.text {
            let newLength = currentText.count + string.count - range.length
            if newLength > 8 {
                return false
            }
        }

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
