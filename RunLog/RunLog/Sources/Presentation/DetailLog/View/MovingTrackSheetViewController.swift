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
import MapKit

final class MovingTrackSheetViewController: UIViewController {
    
    // MARK: - UI
    private let sheetView = MovingTrackSheetView()
    
    // MARK: - DI
    private let viewModel: MovingTrackSheetViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Moving Track 관련 프로퍼티
    /// 모든 섹션의 좌표를 합친 배열
    private var allCoordinates: [CLLocationCoordinate2D] = []
    /// 카메라 이동을 위한 타이머
    private var cameraTimer: Timer?
    /// 현재 카메라가 이동 중인 좌표 인덱스
    private var currentCoordIndex = 0
    
    // 진행 경로를 나타내는 오버레이
    private var progressOverlay: MKPolyline?
    
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
        setupNavigationBar()
        bindGesture()
        setupData()
        bindViewModel()
        setupMapView()
        
        // 1) 전체 경로 계산
        prepareAllCoordinates()
        
        // 2) 전체 경로 폴리라인 그리기
        drawEntireRoute()
        
        // 3) 카메라 애니메이션 시작
        startCameraAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 타이머 해제
        cameraTimer?.invalidate()
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
    
    // MARK: - Setup MapView
    private func setupMapView() {
        let mapView = sheetView.mapView
        
        // 1) 건물 표시 (3D 데이터가 있는 지역에서만 보임)
        mapView.showsBuildings = true
        
        // 2) 사용자가 핀치/드래그 제스처로 지도 기울이거나 회전할 수 있게
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        // 3) 나머지 옵션
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // (Delegate 설정)
        mapView.delegate = self
    }
    
    // MARK: - 전체 경로 관련 메서드
    /// 모든 section의 route를 합쳐 allCoordinates에 저장
    private func prepareAllCoordinates() {
        // 여기서는 dummyDayLog를 사용
        // 실제로는 viewModel을 통해 데이터를 전달받을 예정.
        allCoordinates = dummyDayLog.sections.flatMap { section in
            section.route.map {
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
            }
        }
    }
    
    /// 전체 경로를 단일 폴리라인으로 그려 mapView에 추가
    private func drawEntireRoute() {
        guard !allCoordinates.isEmpty else { return }
        let entirePolyline = MKPolyline(coordinates: allCoordinates, count: allCoordinates.count)
        entirePolyline.title = "전체 경로"
        sheetView.addMapOverlay(entirePolyline)
    }
    
    // MARK: - 3D 카메라 애니메이션 (startCameraAnimation, updateCamera 등)
    
    /// 무빙트랙 애니메이션 시작
    private func startCameraAnimation() {
        guard allCoordinates.count > 1 else { return }
        
        // 기존 타이머 종료
        cameraTimer?.invalidate()
        cameraTimer = nil
        currentCoordIndex = 0
        
        // 초기 카메라 설정
        setCameraToCoordinate(allCoordinates[0], heading: sheetView.mapView.camera.heading)
        
        // 0.2초 간격으로 updateCamera() 호출
        cameraTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                           target: self,
                                           selector: #selector(updateCamera),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    @objc private func updateCamera() {
        guard currentCoordIndex < allCoordinates.count - 1 else {
            cameraTimer?.invalidate()
            cameraTimer = nil
            return
        }
        
        let currentCoord = allCoordinates[currentCoordIndex]
        let nextCoord = allCoordinates[currentCoordIndex + 1]
        
        // 두 좌표 사이의 거리를 계산 (미터 단위)
        let distance = CLLocation(latitude: currentCoord.latitude, longitude: currentCoord.longitude)
                        .distance(from: CLLocation(latitude: nextCoord.latitude, longitude: nextCoord.longitude))
        
        let distanceThreshold: CLLocationDistance = 50  // 예: 50미터 임계값
        
        var targetHeading: CLLocationDirection
        if distance > distanceThreshold {
            // 큰 간격이면 회전을 최소화하거나 현재 heading 유지
            targetHeading = sheetView.mapView.camera.heading
        } else {
            let rawHeading = calculateHeading(from: currentCoord, to: nextCoord)
            // 필요한 경우 오프셋 추가 (예: 뒤에서 보는 시점이라면 +180)
            targetHeading = rawHeading.truncatingRemainder(dividingBy: 360)
        }
        
        // (보간 로직은 필요에 따라 적용)
        UIView.animate(withDuration: 0.24) {
            self.setCameraToCoordinate(nextCoord, heading: targetHeading)
        }
        
        currentCoordIndex += 1
        updateProgressOverlay()
    }
    
    /// 카메라 설정 함수
    private func setCameraToCoordinate(_ coordinate: CLLocationCoordinate2D, heading: CLLocationDirection) {
        let camera = MKMapCamera(
            lookingAtCenter: coordinate,
            fromDistance: 90,
            pitch: 65,
            heading: heading
        )
        sheetView.mapView.camera = camera
    }
    
    /// 두 좌표 간 heading(방위각) 계산
    private func calculateHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDirection {
        let fromLat = from.latitude.deg2rad
        let fromLon = from.longitude.deg2rad
        let toLat = to.latitude.deg2rad
        let toLon = to.longitude.deg2rad
        
        let y = sin(toLon - fromLon) * cos(toLat)
        let x = cos(fromLat) * sin(toLat) - sin(fromLat) * cos(toLat) * cos(toLon - fromLon)
        let radians = atan2(y, x)
        var degrees = radians.rad2deg
        
        if degrees < 0 { degrees += 360 }
        return degrees
    }
    
    /// 보간 함수 (한 번에 최대 maxChange도만 회전)
    private func smoothHeading(currentHeading: CLLocationDirection,
                               targetHeading: CLLocationDirection,
                               maxChange: Double) -> CLLocationDirection {
        var delta = targetHeading - currentHeading
        if delta > 180 { delta -= 360 }
        if delta < -180 { delta += 360 }
        
        if abs(delta) > maxChange {
            delta = (delta > 0) ? maxChange : -maxChange
        }
        
        var newHeading = currentHeading + delta
        if newHeading < 0 { newHeading += 360 }
        else if newHeading >= 360 { newHeading -= 360 }
        return newHeading
    }
    
    // MARK: - 진행 경로 오버레이 업데이트
    private func updateProgressOverlay() {
        // 기존 진행 경로 오버레이 제거
        if let progressOverlay = progressOverlay {
            sheetView.mapView.removeOverlay(progressOverlay)
        }
        
        // 현재 진행된 좌표(시작부터 currentCoordIndex까지)
        let progressCoordinates = Array(allCoordinates.prefix(currentCoordIndex + 1))
        guard progressCoordinates.count >= 2 else { return }
        
        let newOverlay = MKPolyline(coordinates: progressCoordinates, count: progressCoordinates.count)
        newOverlay.title = "진행 경로"
        progressOverlay = newOverlay
        sheetView.addMapOverlay(newOverlay)
    }
}

// MARK: - MKMapViewDelegate
extension MovingTrackSheetViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let renderer = MKPolylineRenderer(polyline: polyline)
        if polyline.title == "전체 경로" {
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
        } else if polyline.title == "진행 경로" {
            renderer.strokeColor = .systemRed
            renderer.lineWidth = 6
        } else {
            // 기본 스타일 지정 (예: 회색)
            renderer.strokeColor = .gray
            renderer.lineWidth = 4
        }
        return renderer
    }
}

