//
//  DetailLogViewController.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import SnapKit
import Then
import Combine

struct RecordDetail {
    let timeRange: String    // 예: "06:12 - 06:18"
    let distance: String     // 예: "1.81km"
    let steps: String        // 예: "345"
}

final class DetailLogViewController: UIViewController {
    
    // MARK: - DI
    private let viewModel: DetailLogViewModel
    private var cancellables = Set<AnyCancellable>()
    private var recordDetails: [RecordDetail] = []
    
    // MARK: - UI
    /// 전체 화면을 구성하는 뷰 (스크롤뷰 포함)
    private let detailLogView = DetailLogView()
    
    // MARK: - Init
    init(viewModel: DetailLogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = detailLogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupGesture()
        setupData()
        bindViewModel()
        detailLogView.onMovingTrackButtonTapped = { [weak self] in
            print("VC에서 버튼 탭 로직 처리")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        title = "0월 0일 (수)"
        navigationController?.setupAppearance() // 스타일 설정
        navigationController?.navigationItem.backButtonTitle = "chevron.left"
        navigationController?.addRightButton(
            icon: "ellipsis",
            target: self,
            action: #selector(buttonTapped)
        )
    }
    
    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        // 더미 데이터
        let dummyRecords = [
            RecordDetail(timeRange: "06:12 - 06:18", distance: "1.81km", steps: "345"),
            RecordDetail(timeRange: "12:13 - 12:30", distance: "1.57km", steps: "1,232"),
            RecordDetail(timeRange: "13:50 - 14:04", distance: "1.61km", steps: "1,234"),
            RecordDetail(timeRange: "18:09 - 18:24", distance: "2.5km", steps: "3,235"),
            RecordDetail(timeRange: "12:13 - 12:30", distance: "100.81km", steps: "1,234"),
            RecordDetail(timeRange: "12:13 - 12:30", distance: "100.81km", steps: "2,237,345"),
            RecordDetail(timeRange: "12:13 - 12:30", distance: "100.81km", steps: "2,237,345")
        ]
        print("DetailLogViewController - 더미데이터 개수: \(dummyRecords.count)")
        // detailLogView 내부에 있는 테이블뷰(RecordDetailView)에 주입
        detailLogView.recordDetailView.setRecords(dummyRecords)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        //        viewModel.output.something
        //            .sink { [weak self] value in
        //                // View 업데이트 로직
        //            }
        //            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        print("오른쪽 네비게이션 버튼 탭됨")
    }
}
