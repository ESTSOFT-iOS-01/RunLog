//
//  ChangeCalUnitViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/15/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class ChangeCalUnitViewController: UIViewController {
    
    // MARK: - DI
//    private let viewModel: ViewModelType
    private var cancellables = Set<AnyCancellable>()
    
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
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
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
//        viewModel.output.something
//            .sink { [weak self] value in
//                // View 업데이트 로직
//            }
//            .store(in: &cancellables)
    }
}
