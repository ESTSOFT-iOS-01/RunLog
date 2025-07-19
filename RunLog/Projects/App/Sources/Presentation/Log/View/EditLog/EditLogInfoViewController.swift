//
//  EditLogInfoViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//
import RLUtil

import UIKit
import SnapKit
import Then
import Combine

final class EditLogInfoViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: EditLogInfoViewModel!
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI
    private var editView = EditLogInfoView()
    
    // MARK: - Init
    init(viewModel: EditLogInfoViewModel) {
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
        setupTableView()
        setupTextField()
        setupGesture()
        
        viewModel.bind()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
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
        view.addSubview(editView)
        
        editView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.title = "기록 관리하기"
        self.navigationController?.setupAppearance(
            backgroundColor: .Gray900,
            foregroundColor: .Gray000,
            font: .RLHeadline1,
            tintColor: .LightGreen
        )
        
        let navigationButton = UIButton()
        navigationButton.setTitleColor(.label, for: .normal)
        navigationButton.titleLabel?.attributedText = .RLAttributedString(
            text: "완료",
            font: .Label1,
            color: .LightGreen,
            align: .center
        )
        
        navigationButton.publisher
            .sink { [weak self] in
                self?.validateAndSaveInfo()
            }
            .store(in: &cancellables)
        
        navigationController?.setupRightButton(navigationButton)
    }
    
    private func setupTableView() {
        editView.tableView.delegate = self
        editView.tableView.dataSource = self
    }

    private func setupTextField() {
        editView.nameField.delegate = self
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        setupTapGestureToDismissKeyboard()
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        viewModel.input.send(.loadData)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.bindTextField(editView.nameField.publisher)
        
        viewModel.output.logNameUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.editView.nameField.setTextWithUnderline(text)
            }
            .store(in: &cancellables)
        
        viewModel.output.logLevelUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.updateSelectedCell(index)
            }
            .store(in: &cancellables)
        
        viewModel.output.saveSuccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] success in
                if success {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    // 저장 실패 시 처리
                }
            }
            .store(in: &cancellables)
            
    }
    
    private func updateSelectedCell(_ selectedIndex: Int?) {
        for (index, cell) in editView.tableView.visibleCells.enumerated() {
            guard let radioButtonCell = cell as? RadioButtonCell else { continue }
            radioButtonCell.changeState(index == selectedIndex)
        }
    }
    
    private func validateAndSaveInfo() {
        guard let text = editView.nameField.text, !text.isEmpty else {
            showAlert(message: "기록 제목을 입력해주세요")
            return
        }
        
        viewModel.input.send(.saveButtonTapped)
    }
}

extension EditLogInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return newText.count <= 14
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditLogInfoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonCell.identifier, for: indexPath) as? RadioButtonCell else {
            return UITableViewCell()
        }
        
        let lvlString = Constants.levels[indexPath.row]
        cell.configure(title: lvlString)
        
        let isSelected = indexPath.row == viewModel.output.logLevelUpdated.value
        cell.changeState(isSelected)
        
        return cell
    }
    
}

extension EditLogInfoViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.send(.logLevelSelected(indexPath.row))
    }
}

