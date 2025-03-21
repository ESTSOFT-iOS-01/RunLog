//
//  RunHomeViewController.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit
import SnapKit
import Then
import Combine
import MapKit

final class RunHomeViewController: UIViewController {
    
    // MARK: - Property
    private let viewModel = RunHomeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private var mapView = MKMapView().then {
        $0.showsUserLocation = true
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        $0.setCameraZoomRange(zoomRange, animated: false)
        $0.initZoomLevel()
    }
    private var totalLabel = UILabel().then {
        $0.numberOfLines = 3
    }
    private var weatherLabel = RLLabel().then {
        $0.setImage(image: UIImage(systemName: RLIcon.weather.name))
        $0.attributedText = .RLAttributedString(text: "Roading", font: .Label2)
    }
    private var blurView = MapBlurView()
    private var locationLabel = UILabel()
    private var startButton = RLButton(
        title: "운동 시작하기",
        titleColor: .Gray900
    ).then {
        $0.clipsToBounds = true
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup
        setupUI()
        setupNavigationBar()
        setupTabBar()
        
        // binding
        viewModel.bind()
        bindViewModel()
        bindGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        view.backgroundColor = .systemBackground
        view.addSubviews(mapView, blurView, totalLabel, weatherLabel, locationLabel, startButton)
        // 상단 레이블
        totalLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(36)
        }
        weatherLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(8)
            $0.leading.equalTo(totalLabel)
        }
        // 맵킷
        mapView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        blurView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(mapView)
        }
        // 운동 시작 버튼
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(52)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        // 위치 레이블
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        self.setupNavigationBarAppearance()
        navigationItem.title = "LOGO"
    }
    
    // MARK: - Setup Tab Bar
    private func setupTabBar() {
        // 탭바 디테일 설정
        self.setupTabBarAppearance()
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 처음 위치를 지도에 표현
        viewModel.input.send(.requestCurrentLocation)
        // 로드(기록)정보 표현
        viewModel.input.send(.requestRoadRecord)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseRunningStart:
                    let vc = RunningViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                case .locationUpdate(let location):
                    self.mapView.centerToLocation(location, region: self.mapView.region)
                case .locationNameUpdate(let text):
                    self.locationLabel.attributedText =
                        .RLAttributedString(
                            text: text,
                            font: .Label2,
                            align: .center
                        )
                case .weatherUpdate(let text):
                    self.weatherLabel.attributedText =
                        .RLAttributedString(
                            text: text,
                            font: .Label2
                        )
                case .responseRoadRecord(let text):
                    self.totalLabel.attributedText = text
                }
            }
            .store(in: &cancellables)
    }
    // MARK: - Bind Gesture
    private func bindGesture() {
        // 제스처 추가
        startButton.publisher
            .sink { [weak self] _ in
                self?.viewModel.input.send(.requestRunningStart)
            }
            .store(in: &cancellables)
    }
}
