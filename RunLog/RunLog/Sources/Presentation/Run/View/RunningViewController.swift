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
    lazy var mapView = MKMapView().then {
        $0.delegate = self
        //최대 줌 거리 제한
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 20000)
        $0.setCameraZoomRange(zoomRange, animated: false)
        $0.showsUserLocation = true
        $0.showsUserTrackingButton = true
        $0.pitchButtonVisibility = .visible
//        $0.overrideUserInterfaceStyle = .light  밝은 지도 - 궁금해서 넣어봄
    }
    var cardView = CardView()
    var foldButton = RLButton().then {
        $0.configureTitle(title: "닫기", titleColor: .Gray000, font: .RLLabel2)
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
    var unfoldButton = UIButton().then {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindGesture()
        setupData()
        bindViewModel()
        
//        LocationManager.shared.startDummyLocationUpdates()
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
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
    }

    // MARK: - Bind Gesture
    private func bindGesture() {
        // 종료 버튼 클릭
        cardView.finishButton.publisher
            .sink { [weak self] in
                LocationManager.shared.isRunning = false
                PedometerManager.shared.stopPedometerUpdate()
//                PedometerManager.shared.stopDummyPedometerUpdates()
//                LocationManager.shared.stopDummyLocationUpdates()
                
                self?.saveLog() // 결과 확인용 alert띄움
//                self?.dismiss(animated: false)
            }
            .store(in: &cancellables)
        // 접기 버튼 클릭
        foldButton.publisher
            .sink { [weak self] in
                self?.toggleCardView()
            }
            .store(in: &cancellables)
        // 펼치기 버튼 클릭
        unfoldButton.publisher
            .sink { [weak self] in
                self?.toggleCardView()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Data
    private func setupData() {
        // 맵뷰 초기 데이터 설정
        let currentLocation = LocationManager.shared.currentLocation
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.centerToLocation(currentLocation)
        // 뷰가 로드되면 운동이 시작된 상태
        viewModel.input.send(.runningStart)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .locationUpdate(let location):
                    self?.mapView.centerToLocation(location, region: self?.mapView.region)
                case .timerUpdate(let time):
                    self?.cardView.timeLabel.setConfigure(text: time)
                case .distanceUpdate(let distance):
                    self?.cardView.distanceLabel.setConfigure(text: distance)
                case .stepsUpdate(let step):
                    self?.cardView.stepsLabel.setConfigure(text: step)
                case .lineDraw(let lineDraw):
//                    print("라인 그리는 중")
                    self?.mapView.addOverlay(lineDraw)
                }
            }
            .store(in: &cancellables)
    }
}

extension RunningViewController: MKMapViewDelegate {
    private func toggleCardView() {
        self.cardView.isHidden.toggle()
        self.foldButton.isHidden.toggle()
        self.unfoldButton.isHidden.toggle()
    }
    // 트래킹모드 .none이 되면 시야조정
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        guard let userLocation = mapView.userLocation.location else { return }
//        if mode == .none {
//            
//        }
        mapView.centerToLocation(userLocation, region: self.mapView.region)
    }
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
    //종료 시 내용 확용 alert를 띄움
    private func saveLog() {
        let message: String =
        """
        ⏹ 운동 종료 ⏹
        최종 시간: \(viewModel.record.sectionTime)초
        최종 경로 핀 수: \(viewModel.section.route.count)
        최종 걸음 수: \(viewModel.section.steps)
        """
        print(message)
        let alert = UIAlertController(
            title: "기록 삭제하기",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: false)
        }
        alert.addAction(okAction)
        self.present(alert,animated: true)
    }
}
