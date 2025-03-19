//
//  EditLogInfoViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/18/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class EditLogInfoViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = EditLogInfoViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI
    private var editView = EditLogInfoView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTableView()
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
        view.addSubview(editView)
        
        editView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationItem.title = "기록 관리하기"
        self.navigationController?.setupAppearance()
        navigationController?
            .addRightButton(title: "완료")
            .sink { [weak self] in
                self?.viewModel.input.send(.saveButtonTapped)
            }
            .store(in: &cancellables)
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
        editView.nameField.setTextWithUnderline(viewModel.logName)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.bindTextField(editView.nameField.publisher)
        
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .logLevelUpdated(let index):
                    self?.updateSelectedCell(index)
                case .saveSuccess:
                    self?.navigationController?.popViewController(animated: true)
                case .logNameUpdated(let text):
                    self?.editView.nameField.setTextWithUnderline(text)
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
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonCell.identifier, for: indexPath) as? RadioButtonCell else {
            return UITableViewCell()
        }
        
        let lvlString = viewModel.items[indexPath.row]
        cell.configure(title: lvlString)
        
        let isSelected = indexPath.row == viewModel.selectedIndex
        cell.changeState(isSelected)
        
        return cell
    }
    
}

extension EditLogInfoViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.send(.logLevelSelected(indexPath.row))
    }
}

