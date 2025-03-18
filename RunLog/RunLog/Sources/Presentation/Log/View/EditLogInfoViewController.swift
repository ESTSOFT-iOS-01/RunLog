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
    
    // MARK: - DI
//    private let viewModel: ViewModelType
    private var cancellables = Set<AnyCancellable>()
    
    private var items : [String] = ["매우 쉬움", "쉬움", "보통", "어려움", "매우 어려움"]

    // MARK: - UI
    private var editView = EditLogInfoView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
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
        // 네비게이션바 디테일 설정
        navigationItem.title = "기록 관리하기"
        self.navigationController?.setupAppearance()
        navigationController?
            .addRightButton(title: "완료")
            .sink { [weak self] in
//                self?.validateAndSaveNickname()
            }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        editView.tableView.delegate = self
        editView.tableView.dataSource = self
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        
    }
}


extension EditLogInfoViewController : UITableViewDelegate {
    
}


extension EditLogInfoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioButtonCell.identifier, for: indexPath) as? RadioButtonCell else {
            return UITableViewCell()
        }
        
        let lvlString = items[indexPath.row]
        cell.configure(title: lvlString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
