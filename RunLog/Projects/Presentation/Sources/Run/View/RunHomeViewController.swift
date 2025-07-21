//
//  RunHomeViewController.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//
import RLDesignSystem
import RLUtil

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
        // 최대 줌아웃 거리 제한
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        $0.setCameraZoomRange(zoomRange, animated: false)
        $0.initZoomLevel()
    }
    
    // 지금까지 운동한 거리에 대한 레이블
    private var RoadRecordLabel = UILabel().then {
        $0.numberOfLines = 3
    }
    
    private var weatherLabel = RLLabel().then {
        $0.setImage(image: UIImage(systemName: RLIcon.weather.name))
        $0.attributedText = .RLAttributedString(text: "Roading", font: .Label2)
    }
    
    private var blurView = MapBlurView()
    
    // 사용자의 현재위치 레이블
    private var locationLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: Constants.LocationMessage.random.message,
            font: .Label2,
            align: .center
        )
    }
    
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
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        view.backgroundColor = .systemBackground
        view.addSubviews(
            mapView,
            blurView,
            RoadRecordLabel,
            weatherLabel,
            locationLabel,
            startButton
        )
        
        // 맵뷰
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        // Road 정보
        RoadRecordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicSize.scaledSize(36))
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(DynamicSize.scaledSize(36))
        }
        
        // 날씨 정보
        weatherLabel.snp.makeConstraints {
            $0.top.equalTo(RoadRecordLabel.snp.bottom).offset(DynamicSize.scaledSize(8))
            $0.leading.equalTo(RoadRecordLabel)
        }
        
        // 운동 시작 버튼
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(DynamicSize.scaledSize(52))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicSize.scaledSize(40))
        }
        
        // 위치 레이블
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top).offset(-DynamicSize.scaledSize(9))
            $0.centerX.equalToSuperview()
        }
        
        // 블러 뷰
        blurView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        self.setupNavigationBarAppearance(titleFont: .RLHeadline1, titleColor: .Gray000)
    }
    
    // MARK: - Setup Tab Bar
    private func setupTabBar() {
        self.setupTabBarAppearance(tintColor: .LightGreen)
        let titleLabel = UILabel().then {
            $0.attributedText = .RLAttributedString(
                text: "Runlog",
                font: .Logo2,
                color: .LightGreen
            )
            $0.textAlignment = .center
        }
        self.navigationController?.setupTitle(label: titleLabel)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 사용자의 위치 정보를 요청
        viewModel.input.send(.requestCurrentLocation)
        // RoadRecord 정보를 요청
        viewModel.input.send(.requestRoadRecord)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                
                switch output {
                    // 운동시작하면 운동화면으로 넘어감
                case .responseRunningStart:
                    let vc = RunningViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false)
                    
                    // 사용자의 변경된 위치 반영
                case .locationUpdate(let location):
                    self.mapView.centerToLocation(location, region: self.mapView.region)
                    
                    // 사용자의 변경된 위치명 반영
                case .locationNameUpdate(let text):
                    self.locationLabel.attributedText =
                        .RLAttributedString(
                            text: text,
                            font: .Label2,
                            align: .center
                        )
                    
                    // 변경된 날씨 정보 반영
                case .weatherUpdate(let text):
                    self.weatherLabel.attributedText =
                        .RLAttributedString(
                            text: text,
                            font: .Label2
                        )
                    
                    //  RoadRecord 정보 표시
                case .responseRoadRecord(let text):
                    self.RoadRecordLabel.attributedText = text
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
