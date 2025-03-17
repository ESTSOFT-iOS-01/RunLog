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
    
    // MARK: - DI
    private let viewModel = CalUnitViewModel()
    private lazy var calUnitView = CalUnitView(viewModel: viewModel)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    //    init(viewModel: ViewModelType) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }

    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
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
        self.navigationController?.addRightButton(title: "완료", target: self, action: #selector(saveButtonTapped))
        self.navigationController?.setupAppearance()
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
        // 초기 데이터 로드
        calUnitView.unitField.setTextWithUnderline(String(viewModel.unit))
        calUnitView.updateDescriptionText(with: viewModel.unit)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .saveSuccess:
                    self?.navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func saveButtonTapped() {
        guard let text = calUnitView.unitField.text, !text.isEmpty else {
            showAlert(message: "값을 입력해주세요.")
            return
        }
        
        viewModel.input.send(.saveButtonTapped)
    }
    
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

}

extension ChangeCalUnitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
