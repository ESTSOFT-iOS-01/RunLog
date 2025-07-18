//
//  MyPageViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//
import RLUtil

import UIKit
import SnapKit
import Then
import Combine

/// 마이페이지 화면을 구성하는 ViewController
final class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: MyPageViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private var mypageView = MypageProfileView()
    
    // MARK: - Init
    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()                 // 화면 구성
        setupNavigationBar()     // 네비게이션 바 설정
        setupTableView()         // 테이블뷰 바인딩
        
        viewModel.bind()         // ViewModel의 입력 수신 준비
        bindViewModel()          // ViewModel의 출력 바인딩
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.send(.loadData) // 데이터 새로 불러오기
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .Gray900
        view.addSubview(mypageView)
        
        mypageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        self.navigationController?.setupAppearance()
        self.navigationController?.setupLogoTitle()
    }
    
    private func setupTableView() {
        mypageView.tableView.delegate = self
        mypageView.tableView.dataSource = self
    }

    // MARK: - ViewModel Output Binding
    private func bindViewModel() {
        // 로딩 상태 변경
        viewModel.output.stopLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] off in
                off ? self?.stopLoading() : self?.startLoading()
            }
            .store(in: &cancellables)
        
        // 프로필 데이터 업데이트
        viewModel.output.profileDataUpdated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] config in
                self?.mypageView.configure(with: config)
            }
            .store(in: &cancellables)
        
        // 화면 전환 처리
        viewModel.output.navigateToViewController
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewController in
                if let vc = viewController {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "설정"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        // 섹션 헤더 스타일 커스터마이징
        header.textLabel?.frame.origin.x = 4
        header.textLabel?.textAlignment = .left
        header.textLabel?.attributedText = .RLAttributedString(
            text: header.textLabel?.text ?? "설정",
            font: .Label1,
            color: .Gray100
        )
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 메뉴 항목 선택 시 ViewModel에 전달
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input.send(.menuItemSelected(indexPath.row))
    }
}

// MARK: - UITableViewDataSource
extension MyPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingMenuType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 메뉴 셀 구성
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuCell.identifier, for: indexPath) as? SettingMenuCell else {
            return UITableViewCell()
        }
        
        cell.configure(title: SettingMenuType.allCases[indexPath.row].title)
        return cell
    }
}
