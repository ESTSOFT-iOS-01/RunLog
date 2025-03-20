//
//  ChangeNicknameViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class ChangeNicknameViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel : ChangeNicknameViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private lazy var nicknameView = ChangeNicknameView()
    
    // MARK: - Init
    init(viewModel: ChangeNicknameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupGesture()
        setupTextField()
        bindViewModel()
        setupData()
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
        view.backgroundColor = .Gray900
        view.addSubview(nicknameView)
        
        nicknameView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview().offset(130)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        navigationItem.title = "닉네임 수정"
        self.navigationController?.setupAppearance()
        navigationController?
            .addRightButton(title: "완료")
            .sink { [weak self] in
                self?.validateAndSaveNickname()
            }
            .store(in: &cancellables)
    }
    
    private func setupTextField() {
        nicknameView.nameField.delegate = self
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        setupTapGestureToDismissKeyboard()
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        viewModel.input.send(.loadData)
        nicknameView.nameField.setTextWithUnderline(viewModel.nickname)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .nicknameUpdated(let text):
                    self?.nicknameView.nameField.setTextWithUnderline(text)
                case .saveSuccess:
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.bindTextField(nicknameView.nameField.publisher)
    }
    
    private func validateAndSaveNickname() {
        guard let text = nicknameView.nameField.text, !text.isEmpty else {
            showAlert(message: "닉네임을 입력해주세요.")
            return
        }
        viewModel.input.send(.saveButtonTapped)
    }

}

extension ChangeNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
