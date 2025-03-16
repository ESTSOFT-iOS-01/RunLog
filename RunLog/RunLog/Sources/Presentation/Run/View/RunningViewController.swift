//
//  RunningViewController.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import UIKit
import SnapKit
import Then
import Combine
import MapKit

struct SectionRecord {
    var sectionTime: TimeInterval // 시간
    var distance: Double // 거리
    var steps: Int // 걸음 수
}

final class RunningViewController: UIViewController {
    
    // MARK: - DI
//    private let viewModel: ViewModelType
    private var cancellables = Set<AnyCancellable>()
    var record = SectionRecord(
        sectionTime: 12 * 60 + 23,
        distance: 0.93,
        steps: 3242
    )
    // MARK: - UI
    var mapView = MKMapView()
    var cardView = CardView()
    var foldButton = RLButton().then {
        $0.configureTitle(title: "닫기", titleColor: .Gray000, font: .RLLabel2)
        $0.setHeight(32)
        $0.configureRadius(8)
        $0.configureBackgroundColor(.Gray700)
        $0.tintColor = .Gray000
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: RLIcon.foldButton.name)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        $0.configuration = config
    }
    var unfoldButton = UIButton().then {
        $0.backgroundColor = .LightGreen
        $0.layer.cornerRadius = 40
        $0.isHidden = true
    }
    
    // MARK: - Init
//    init(viewModel: ViewModelType) {
//        self.viewModel = viewModel
    init() {
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        view.backgroundColor = .systemBackground
        view.addSubviews(mapView, cardView, foldButton, unfoldButton)
        
        // 맵킷
        mapView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        // 카드 뷰
        cardView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(299)
        }
        foldButton.snp.makeConstraints {
            $0.width.equalTo(76)
            $0.bottom.equalTo(cardView.snp.top).offset(-8)
            $0.trailing.equalToSuperview().inset(16)
        }
        unfoldButton.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.trailing.equalToSuperview().inset(40)
            $0.bottom.equalToSuperview().inset(64)
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
    }

    // MARK: - Setup Gesture
    private func setupGesture() {
        // 제스처 추가
        cardView.finishButton.addTarget(self, action: #selector(finishButtonTouch), for: .touchUpInside)
        foldButton.addTarget(self, action: #selector(foldButtonTouch), for: .touchUpInside)
        unfoldButton.addTarget(self, action: #selector(unfoldButtonTouch), for: .touchUpInside)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        cardView.timeLabel.record = record
        cardView.distanceLabel.record = record
        cardView.stepsLabel.record = record
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

extension RunningViewController {
    @objc private func finishButtonTouch(sender: UIButton) {
        print("종료 버튼 클릭")
        self.dismiss(animated: false)
    }
    @objc private func foldButtonTouch(sender: UIButton) {
        print("닫기 버튼 클릭")
        self.cardView.isHidden = true
        self.foldButton.isHidden = true
        self.unfoldButton.isHidden = false
    }
    @objc private func unfoldButtonTouch(sender: UIButton) {
        print("열기 버튼 클릭")
        self.cardView.isHidden = false
        self.foldButton.isHidden = false
        self.unfoldButton.isHidden = true
    }
}
