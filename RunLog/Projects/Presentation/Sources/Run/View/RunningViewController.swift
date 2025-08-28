//
//  RunningViewController.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//
import RLDesignSystem
import RLUtil

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
        
        //최대 줌아웃 거리 제한
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        $0.setCameraZoomRange(zoomRange, animated: false)
        $0.showsUserLocation = true
        $0.showsUserTrackingButton = true
        $0.pitchButtonVisibility = .visible
        $0.initZoomLevel()
    }
    
    // 카드 뷰
    private var cardView = CardView()
    
    // 카드 뷰 접는 버튼
    private var foldButton = RLButton().then {
        $0.setHeight(DynamicSize.scaledSize(40)) // 높이 지정
        $0.configureRadius(DynamicSize.scaledSize(8)) // 라운드 지정
        $0.configureBackgroundColor(.Gray700) // 배경색 지정
        
        $0.setRightIcon(systemName: RLIcon.fold.name) // 아이콘 지정
        $0.setAttributedString(
            title: .RLAttributedString(
                text: "닫기",
                font: .Label2,
                align: .center
            )
        )
    }
    
    // 카드 뷰 펼치는 버튼
    private var unfoldButton = UIButton().then {
        $0.backgroundColor = .LightGreen
        $0.layer.cornerRadius = DynamicSize.scaledSize(40)
        $0.setImage(UIImage(systemName: RLIcon.unfold.name), for: .normal)
        $0.tintColor = .Gray900
        
        let sfConfig = UIImage.SymbolConfiguration(
            pointSize: DynamicSize.scaledSize(32),
            weight: .medium
        )
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
        bindViewModel()
        bindGesture()
        viewModel.bind()
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
            $0.leading.trailing.equalToSuperview().inset(DynamicSize.scaledSize(16))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicSize.scaledSize(24))
            $0.height.equalTo(DynamicSize.scaledSize(299))
        }
        
        // 카드 뷰 접는 버튼
        foldButton.snp.makeConstraints {
            $0.width.equalTo(DynamicSize.scaledSize(80))
            $0.bottom.equalTo(cardView.snp.top).offset(-DynamicSize.scaledSize(8))
            $0.trailing.equalToSuperview().inset(DynamicSize.scaledSize(16))
        }
        
        // 카드 뷰 펼치는 버튼
        unfoldButton.snp.makeConstraints {
            $0.width.height.equalTo(DynamicSize.scaledSize(80))
            $0.trailing.equalToSuperview().inset(DynamicSize.scaledSize(16))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicSize.scaledSize(24))
        }
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .currentTime(let time):
                    self.cardView.timeLabel.setConfigure(text: time.asTimeString)
                    
                case .currentLocation(let location):
                    self.mapView.centerToLocation(location, region: self.mapView.region)
                    
                case .currentDistance(let distance):
                    self.cardView.distanceLabel.setConfigure(
                        text: String(format: "%.2fkm", distance)
                    )
                    
                case .currentSteps(let steps):
                    self.cardView.stepsLabel.setConfigure(text: String(steps))
                
                // 지도에 이동한 루트 표시
                case .currentRoutes(let routes):
                    self.mapView.addOverlay(MKPolyline(coordinates: routes, count: routes.count))
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Bind Gesture
    private func bindGesture() {
        
        // 카드뷰 접었다 펴기 - 뷰의 형태만 다르고 같은 내용을 사용
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
                self?.viewModel.input.send(.requestRunningStop)
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: -  MKMapViewDelegate 함수
extension RunningViewController: MKMapViewDelegate {
    
    // 트랙킹 모드 변경
    func mapView(
        _ mapView: MKMapView,
        didChange mode: MKUserTrackingMode,
        animated: Bool
    ) {
        guard let userLocation = mapView.userLocation.location else { return }
        
        // none이 되면 현재위치로 지도 바로 이동
        if mode == .none {
            mapView.centerToLocation(
                userLocation,
                region: self.mapView.region
            )
        }
    }
    
    // 풀리라인 설정
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        
        guard let polyLine = overlay as? MKPolyline else {
            print("can't draw polyline")
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .LightGreen
        renderer.lineWidth = DynamicSize.scaledSize(3.0)
        renderer.alpha = 1.0
        
        return renderer
    }
}
