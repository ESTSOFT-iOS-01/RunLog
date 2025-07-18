//
//  ChangeCalUnitViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//
import RLUtil

import UIKit
import SnapKit
import Then
import Combine

/// 기록 시각화 단위(거리)를 설정하는 화면의 ViewController
final class ChangeCalUnitViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: CalUnitViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private lazy var calUnitView = CalUnitView()
    
    // MARK: - Init
    init(viewModel: CalUnitViewModel) {
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
        setupTextField()       // 텍스트 필드 설정
        
        viewModel.bind()       // ViewModel 입력 바인딩
        bindViewModel()        // ViewModel 출력 바인딩
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData() // 초기 데이터 요청
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .Gray900
        view.addSubview(calUnitView)
        
        calUnitView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.title = "기록 시각화 단위 설정"
        self.navigationController?.setupAppearance()
        
        // 우측 '완료' 버튼 설정 및 동작 바인딩
        navigationController?
            .addRightButton(title: "완료")
            .sink { [weak self] in
                self?.validateAndSaveUnit()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Gesture
    private func setupGesture() {
        setupTapGestureToDismissKeyboard()
    }
    
    private func setupTextField() {
        calUnitView.unitField.delegate = self
    }
    
    // MARK: - Setup Data
    private func setupData() {
        viewModel.input.send(.loadData)
    }

    // MARK: - ViewModel Output Binding
    private func bindViewModel() {
        // 텍스트필드 실시간 값 전달
        viewModel.bindTextField(calUnitView.unitField.publisher)
        
        // 거리 값 변경 시 UI 갱신
        viewModel.output.unitUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.calUnitView.unitField.setTextWithUnderline(value)
                self?.calUnitView.updateDescriptionText(with: value)
            }
            .store(in: &cancellables)
        
        // 저장 성공 시 뒤로 이동
        viewModel.output.saveSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    // 저장 실패 시 처리 가능
                }
            }
            .store(in: &cancellables)
    }
    
    /// 입력값 유효성 검사 후 저장 요청
    private func validateAndSaveUnit() {
        guard let text = calUnitView.unitField.text,
              let value = Double(text),
              value > 0 else {
            showAlert(message: "올바른 값을 입력해주세요.")
            return
        }
        viewModel.input.send(.saveButtonTapped)
    }
}

// MARK: - UITextFieldDelegate
extension ChangeCalUnitViewController: UITextFieldDelegate {
    
    /// 허용된 값(숫자, 소수점 포함) 및 최대 자릿수 제한
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
        
        let newLength = currentText.count + string.count - range.length
        if newLength > 8 {
            return false
        }

        return true
    }
    
    /// Return 키로 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
