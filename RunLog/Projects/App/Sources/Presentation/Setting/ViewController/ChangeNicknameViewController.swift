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

/// 닉네임을 변경하는 화면을 담당하는 ViewController
final class ChangeNicknameViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ChangeNicknameViewModel!
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
        
        setupUI()              // 화면 구성
        setupNavigationBar()   // 네비게이션 바 설정
        setupGesture()         // 키보드 닫기 제스처
        setupTextField()       // 텍스트필드 설정
        
        viewModel.bind()       // ViewModel 입력 바인딩
        bindViewModel()        // ViewModel 출력 바인딩
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData() // 데이터 초기화
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
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.title = "닉네임 수정"
        self.navigationController?.setupAppearance()
        
        // 네비게이션바 우측 완료 버튼 바인딩
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
        // 초기 데이터 요청
        viewModel.input.send(.loadData)
    }

    // MARK: - ViewModel Output Binding
    private func bindViewModel() {
        // 닉네임 값 반영
        viewModel.output.nicknameUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.nicknameView.nameField.setTextWithUnderline(text)
            }
            .store(in: &cancellables)
        
        // 저장 성공 시 화면 닫기
        viewModel.output.saveSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    // 저장 실패 시 처리 로직 필요 시 여기에
                }
            }
            .store(in: &cancellables)
        
        // 텍스트 필드 입력값을 ViewModel로 전달
        viewModel.bindTextField(nicknameView.nameField.publisher)
    }
    
    /// 유효성 검사 후 닉네임 저장 요청
    private func validateAndSaveNickname() {
        guard let text = nicknameView.nameField.text, !text.isEmpty else {
            showAlert(message: "닉네임을 입력해주세요.")
            return
        }
        viewModel.input.send(.saveButtonTapped)
    }

}

// MARK: - UITextFieldDelegate
extension ChangeNicknameViewController: UITextFieldDelegate {
    
    /// 닉네임은 최대 10자까지 허용
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 10
    }
    
    /// Return 키로 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
