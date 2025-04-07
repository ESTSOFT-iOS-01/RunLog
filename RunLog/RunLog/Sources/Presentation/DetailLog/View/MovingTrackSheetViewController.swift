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
    private let viewModel: DetailLogViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Moving Track 관련 프로퍼티
    /// 각 섹션별 좌표 배열
    private var sectionsCoordinates: [[CLLocationCoordinate2D]] = []
    /// 현재 섹션 인덱스
    private var currentSectionIndex = 0
    /// 현재 섹션 내 좌표 인덱스
    private var currentCoordIndexInSection = 0
    /// 카메라 이동을 위한 타이머
    private var cameraTimer: Timer?
    /// 진행 경로를 누적하는 배열 (현재 섹션 내)
    private var accumulatedProgressCoordinates: [CLLocationCoordinate2D] = []
    
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
        view = sheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindGesture()
        setupData()
        bindViewModel()
        setupMapView()
        prepareSectionsCoordinates()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 타이머 해제
        cameraTimer?.invalidate()
    }
    
    // MARK: - Setup Navigation Bar
    /// 네비게이션 바 설정 (추가 설정 필요 시 이곳에 구현)
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
    }
    
    // MARK: - Setup Gesture
    /// 닫기 버튼에 대한 제스처를 바인딩하는 메서드
    private func bindGesture() {
        sheetView.closeButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Data
    /// 초기 데이터 로드를 위한 메서드 (필요 시 구현)
    private func setupData() {
        // 초기 데이터 로드
    }
    
    // MARK: - Bind ViewModel
    /// 뷰모델의 출력 이벤트를 구독하여 UI 업데이트 및 액션을 처리하는 메서드
    private func bindViewModel() {
        // 예시 코드 - 필요 시 구현
        // viewModel.output.something
        //     .sink { [weak self] value in
        //         // View 업데이트 로직
        //     }
        //     .store(in: &cancellables)
    }
    
    // MARK: - Setup MapView
    /// MapView의 설정 및 기본 옵션 적용, 뷰모델에서 전달된 날짜를 반영
    private func setupMapView() {
        let mapView = sheetView.mapView
        
        // 사용자 상호작용 비활성화
        mapView.isUserInteractionEnabled = false
        
        // 1) 3D 건물 표시 활성화 (해당 지역에서만 적용)
        mapView.showsBuildings = true
        
        // 2) 지도 기울이기 및 회전 가능
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        // 3) 추가 옵션 적용: 나침반, 축척 표시
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // Delegate 설정
        mapView.delegate = self
        
        // 뷰모델의 dayLogPublisher를 통해 날짜 전달 및 뷰 업데이트
        viewModel.dayLogPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dayLog in
                self?.sheetView.configure(with: dayLog.date)
            }
            .store(in: &cancellables)
    }
    
    /// 각 섹션의 route 데이터를 sectionsCoordinates에 저장하고 애니메이션 시작 준비
    private func prepareSectionsCoordinates() {
        viewModel.dayLogPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dayLog in
                guard let self = self else { return }
                // 각 섹션별 route를 timestamp 순으로 정렬 후 좌표 배열로 변환
                self.sectionsCoordinates = dayLog.sections.map { section in
                    section.route
                        .sorted(by: { $0.timestamp < $1.timestamp })
                        .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                }
                
                // 전체 경로 오버레이 그리기
                self.drawAllSectionOverlays()
                
                // 첫 섹션에 대해 카메라 애니메이션 시작
                self.startCameraAnimationForCurrentSection()
            }
            .store(in: &cancellables)
    }
    
    /// 각 섹션별 전체 경로 오버레이를 지도에 그리는 메서드
    private func drawAllSectionOverlays() {
        let mapView = sheetView.mapView
        mapView.removeOverlays(mapView.overlays)
        
        for (index, sortedCoordinates) in sectionsCoordinates.enumerated() {
            guard sortedCoordinates.count >= 2 else { continue }
            let polyline = MKPolyline(coordinates: sortedCoordinates, count: sortedCoordinates.count)
            polyline.title = "전체 경로-\(index)"
            sheetView.addMapOverlay(polyline)
        }
    }
    
    // MARK: - 3D 카메라 애니메이션 (섹션별)
    /// 현재 섹션에 대해 카메라 애니메이션을 시작하는 메서드
    private func startCameraAnimationForCurrentSection() {
        guard currentSectionIndex < sectionsCoordinates.count else { return }
        let sectionCoords = sectionsCoordinates[currentSectionIndex]
        guard sectionCoords.count > 1 else { return }
        
        // 타이머 초기화 및 섹션 내 좌표 인덱스 재설정
        cameraTimer?.invalidate()
        cameraTimer = nil
        currentCoordIndexInSection = 0
        
        // 누적 좌표 배열 초기화 후 첫 좌표 추가 및 카메라 초기 설정
        accumulatedProgressCoordinates = []
        if let firstCoord = sectionCoords.first {
            accumulatedProgressCoordinates.append(firstCoord)
            setCameraToCoordinate(firstCoord, heading: sheetView.mapView.camera.heading)
        }
        
        // 타이머 시작: 0.2초 간격으로 카메라 업데이트
        cameraTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                           target: self,
                                           selector: #selector(updateCameraForSection),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    /// 섹션 내에서 카메라 위치와 heading을 업데이트하고, 진행 구간 오버레이를 추가하는 메서드
    @objc private func updateCameraForSection() {
        let sectionCoords = sectionsCoordinates[currentSectionIndex]
        guard currentCoordIndexInSection < sectionCoords.count - 1 else {
            moveToNextSectionIfAvailable()
            return
        }
        
        let currentCoord = sectionCoords[currentCoordIndexInSection]
        let nextCoord = sectionCoords[currentCoordIndexInSection + 1]
        
        // 현재 좌표와 다음 좌표 간의 heading 계산
        let rawHeading = calculateHeading(from: currentCoord, to: nextCoord)
        let targetHeading = rawHeading.truncatingRemainder(dividingBy: 360)
        
        // 애니메이션을 통한 카메라 이동
        UIView.animate(withDuration: 0.2) {
            self.setCameraToCoordinate(nextCoord, heading: targetHeading)
        }
        
        // 진행 좌표 누적 및 세그먼트 오버레이 추가
        accumulatedProgressCoordinates.append(nextCoord)
        if accumulatedProgressCoordinates.count >= 2 {
            let lastTwoCoords = Array(accumulatedProgressCoordinates.suffix(2))
            let segmentPolyline = MKPolyline(coordinates: lastTwoCoords, count: lastTwoCoords.count)
            segmentPolyline.title = "진행 경로"
            sheetView.addMapOverlay(segmentPolyline)
        }
        
        currentCoordIndexInSection += 1
    }
    
    /// 현재 섹션이 끝나면 다음 섹션으로 전환하는 메서드 (있을 경우)
    private func moveToNextSectionIfAvailable() {
        if currentSectionIndex < sectionsCoordinates.count - 1 {
            currentSectionIndex += 1
            currentCoordIndexInSection = 0
            accumulatedProgressCoordinates = []
            let nextSectionCoords = sectionsCoordinates[currentSectionIndex]
            if let firstCoord = nextSectionCoords.first {
                accumulatedProgressCoordinates.append(firstCoord)
                setCameraToCoordinate(firstCoord, heading: sheetView.mapView.camera.heading)
            }
        } else {
            // 모든 섹션 완료 시 타이머 종료
            cameraTimer?.invalidate()
            cameraTimer = nil
        }
    }
    
    /// 주어진 좌표와 heading으로 카메라를 설정하는 메서드
    private func setCameraToCoordinate(_ coordinate: CLLocationCoordinate2D, heading: CLLocationDirection) {
        let camera = MKMapCamera(
            lookingAtCenter: coordinate,
            fromDistance: 90,
            pitch: 65,
            heading: heading
        )
        sheetView.mapView.camera = camera
    }
    
    /// 두 좌표 간의 heading(방위각)을 계산하는 메서드
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
}

// MARK: - MKMapViewDelegate
extension MovingTrackSheetViewController: MKMapViewDelegate {
    /// 오버레이 렌더러를 설정하여 진행 경로와 전체 경로를 구분하여 그린다.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline, let title = polyline.title else {
            return MKOverlayRenderer()
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        if title == "진행 경로" {
            renderer.strokeColor = .NormalGreen
            renderer.lineWidth = 6
        } else {
            renderer.strokeColor = .LightGreen
            renderer.lineWidth = 5
        }
        return renderer
    }
}
