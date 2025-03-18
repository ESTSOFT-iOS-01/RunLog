//
//  MyPageViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = MyPageViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private var mypageView = MypageProfileView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTableView()
        bindViewModel()
        viewModel.input.send(.loadData)
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
        view.addSubview(mypageView)
        mypageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        navigationItem.title = "LOGO"
        self.navigationController?.setupAppearance()
    }
    
    private func setupTableView() {
        mypageView.tableView.delegate = self
        mypageView.tableView.dataSource = self
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .sink { [weak self] output in
                switch output {
                case .profileDataUpdated(let config):
                    self?.mypageView.configure(with: config)
                case .navigateToViewController(let viewController):
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}


extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "설정"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.frame.origin.x = 4
        header.textLabel?.textAlignment = .left
        header.textLabel?.attributedText = .RLAttributedString(text: header.textLabel?.text ?? "설정", font: .Label1, color: .Gray100)
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMenuItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as? SettingMenuCell else {
            return UITableViewCell()
        }
        
        let menuType = viewModel.menuItem(at: indexPath.row)
        cell.configure(title: menuType.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.send(.menuItemSelected(indexPath.row))
    }
    
}
