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
    private lazy var mapView = MKMapView().then {
        $0.showsUserLocation = true
    }
    private var totalLabel = UILabel().then {
        $0.numberOfLines = 3
    }
    private var weatherLabel = RLLabel().then {
        $0.setImage(image: UIImage(systemName: RLIcon.weather.name))
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
        setupUI()
        setupNavigationBar()
        setupTabBar()
        bindGesture()
        setupData()
        bindViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.centerToLocation(LocationManager.shared.currentLocation)
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
    // MARK: - Bind Gesture
    private func bindGesture() {
        // 제스처 추가
        startButton.publisher
            .receive(on: DispatchQueue.main)
            .sink {
                // +) 코디네이터를 쓰면 해당 부분들이 전부 거기로 넘어갈듯
                PedometerManager.shared.input.send(.startPedometer)
                let vc = RunningViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
            .store(in: &cancellables)
    }
    // MARK: - Setup Data
    private func setupData() {
        // 초기 데이터 로드
        totalLabelCreate(value: ("올레길", "2.5"))
    }
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .locationUpdate(let location):
                    self?.mapView.centerToLocation(location)
                case .locationNameUpdate(let text):
                    self?.locationLabel.attributedText = .RLAttributedString(text: text, font: .Label2, align: .center)
                case .weatherUpdate(let text):
                    self?.weatherLabel.attributedText = .RLAttributedString(text: text, font: .Label2)
                }
            }
            .store(in: &cancellables)
    }
}
// MARK: - private functions
extension RunHomeViewController {
    private func totalLabelCreate(value: (String, String)) {
        // 여기서 사용자의 데이터를 받아오면 될듯
        let nickname = "행복한 쿼카러너화이팅"
        let road = value.0
        let number = value.1
        let string: String = "\(nickname) 님은\n지금까지 \(road) \(number)회\n거리만큼 걸었습니다!"
        totalLabel.attributedText = string.styledText(
            highlightText: "\(road) \(number)회",
            baseFont: .RLMainTitle,
            highlightFont: .RLMainTitle
        )
    }
}
