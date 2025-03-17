//
//  ChangeNicknameView.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import Combine
import SnapKit
import Then

final class ChangeNicknameView: UIView {
    
    // MARK: - Properties
    private let viewModel: ChangeNicknameViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let placeHolderString = "최대 10자까지 입력 가능합니다"
    
    lazy var nameField = RLTextField(placeholder: placeHolderString).then {
        $0.keyboardType = .default
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Init
    init(viewModel: ChangeNicknameViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .Gray900
        addSubview(nameField)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        nameField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .nicknameUpdated(let text):
                    self?.nameField.setTextWithUnderline(text)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Handle TextField Input
    @objc private func textFieldDidChange() {
        viewModel.input.send(.nicknameChanged(nameField.text ?? ""))
    }
    
}
