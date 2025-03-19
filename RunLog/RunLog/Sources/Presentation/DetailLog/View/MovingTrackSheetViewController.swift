//
//  MovingTrackSheetViewController.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import SnapKit
import Then
import Combine

final class MovingTrackSheetViewController: UIViewController {
    
    // MARK: - UI
    private let sheetView = MovingTrackSheetView()
    
    // MARK: - DI
    private let viewModel: MovingTrackSheetViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: MovingTrackSheetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = sheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindGesture()
        setupData()
        bindViewModel()
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
    }
    
    // MARK: - Setup Gesture
    private func bindGesture() {
        // 제스처 추가
        sheetView.closeButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
        
        sheetView.saveButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                print("동선 영상 저장 로직 실행")
            }
            .store(in: &cancellables)
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
