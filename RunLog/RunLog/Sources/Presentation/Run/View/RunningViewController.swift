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

final class RunningViewController: UIViewController {
    
    // MARK: - Property
    private let viewModel = RunningViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    private lazy var mapView = MKMapView().then {
        $0.delegate = self
        //최대 줌 거리 제한
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        $0.setCameraZoomRange(zoomRange, animated: false)
        $0.showsUserLocation = true
        $0.showsUserTrackingButton = true
        $0.pitchButtonVisibility = .visible
        $0.initZoomLevel()
    }
    // 카드 뷰
    private var cardView = CardView()
    private var foldButton = RLButton().then {
        $0.configureTitle(
            title: "닫기",
            titleColor: .Gray000,
            font: .RLLabel2
        )
        $0.setHeight(32)
        $0.configureRadius(8)
        $0.configureBackgroundColor(.Gray700)
        $0.tintColor = .Gray000
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: RLIcon.fold.name)
        config.imagePadding = 4
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
            pointSize: 12,
            weight: .medium
        )
        $0.configuration = config
    }
    private var unfoldButton = UIButton().then {
        $0.backgroundColor = .LightGreen
        $0.layer.cornerRadius = 40
        $0.setImage(UIImage(systemName: RLIcon.unfold.name), for: .normal)
        $0.tintColor = .Gray900
        let sfConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        $0.setPreferredSymbolConfiguration(sfConfig, forImageIn: .normal)
        $0.isHidden = true
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup
        setupUI()
        
        // binding
        viewModel.bind()
        bindViewModel()
        bindGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setupData()
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
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 처음 위치를 지도에 표현
        viewModel.input.send(.requestCurrentLocation)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .responseRunningStop:
                    self.dismiss(animated: false)
                case .locationUpdate(let location):
                    self.mapView.centerToLocation(location, region: self.mapView.region)
                case .responseCurrentTimes(let time):
                    self.cardView.timeLabel.setConfigure(text: time)
                case .responseCurrentDistances(let distances):
                    self.cardView.distanceLabel.setConfigure(text: distances)
                case .responseCurrentSteps(let steps):
                    self.cardView.stepsLabel.setConfigure(text: steps)
                case .lineDraw(let polyline):
                    self.mapView.addOverlay(polyline)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Bind Gesture
    private func bindGesture() {
        // 카드뷰 접었다 펴기
        Publishers.Merge(
            foldButton.publisher,
            unfoldButton.publisher
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] in
            guard let self = self else { return }
            self.cardView.isHidden.toggle()
            self.foldButton.isHidden.toggle()
            self.unfoldButton.isHidden.toggle()
        }
        .store(in: &cancellables)
        
        // 종료 버튼 클릭
        cardView.finishButton.publisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.viewModel.input.send(.requestRunningStop)
            }
            .store(in: &cancellables)
    }
}

// MARK: -  MKMapViewDelegate 함수
extension RunningViewController: MKMapViewDelegate {
    // 트랙킹 모드 변경
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        guard let userLocation = mapView.userLocation.location else { return }
        if mode == .none { // none이 되면 현재위치로 지도 바로 이동
            mapView.centerToLocation(userLocation, region: self.mapView.region)
        }
    }
    // 풀리라인 설정
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .LightGreen
        renderer.lineWidth = 3.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
