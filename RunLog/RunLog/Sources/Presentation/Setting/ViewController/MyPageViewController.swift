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
    
    // MARK: - DI
//    private let viewModel: ViewModelType
    private var cancellables = Set<AnyCancellable>()
    private let menuItems: [SettingMenuType] = SettingMenuType.allCases
    
    // MARK: - UI
    private var mypageView = MypageProfileView(nickname: "행복한쿼카러너", totalDistance: 100, logCount: 1000, streakCount: 14)
    
    
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
        setupTableView()
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
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
    }
    
    private func setupTableView() {
        mypageView.tableView.delegate = self
        mypageView.tableView.dataSource = self
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
//        viewModel.output.something
//            .sink { [weak self] value in
//                // View 업데이트 로직
//            }
//            .store(in: &cancellables)
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
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as? SettingMenuCell else {
            return UITableViewCell()
        }
        
        let menuType = menuItems[indexPath.row]
        cell.configure(title: menuType.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 이후 페이지 완성되면 연결
        // coordinator 패턴쓰면 그걸로도 처리할 수 있을 듯?
        print("\(menuItems[indexPath.row].viewControllerType) 선택됨")
    }
    
}
