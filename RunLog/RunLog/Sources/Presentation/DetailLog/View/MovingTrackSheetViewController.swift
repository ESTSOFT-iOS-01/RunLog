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
    /// 각 섹션별 좌표 배열
    private var sectionsCoordinates: [[CLLocationCoordinate2D]] = []
    /// 현재 섹션 인덱스
    private var currentSectionIndex = 0
    /// 현재 섹션 내 좌표 인덱스
    private var currentCoordIndexInSection = 0
    /// 카메라 이동을 위한 타이머
    private var cameraTimer: Timer?
    
    // 진행 경로 오버레이 (전체 경로 오버레이와는 별도로, 현재 진행된 섹션만 표시)
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
    override func loadView() { view = sheetView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bindGesture()
        setupData()
        bindViewModel()
        setupMapView()
        
        // 1) 섹션별 경로 계산
        prepareSectionsCoordinates()
        // 2) 전체 경로 오버레이 (각 섹션 별 오버레이를 모두 그리기)
        drawAllSectionOverlays()
        // 3) 첫 섹션의 카메라 애니메이션 시작
        startCameraAnimationForCurrentSection()
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
    
    // MARK: - 섹션별 경로 관련 메서드
        
        /// 각 섹션의 route를 그대로 sectionsCoordinates에 저장
        private func prepareSectionsCoordinates() {
            // 여기서는 dummyDayLog를 사용. 실제로는 viewModel.dayLog.sections를 활용.
            sectionsCoordinates = dummyDayLog.sections.map { section in
                section.route.map {
                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                }
            }
        }
        
        /// 각 섹션별로 오버레이를 그려 전체 경로를 표현 (섹션 간 구분)
        private func drawAllSectionOverlays() {
            let mapView = sheetView.mapView
            // 기존 오버레이 제거
            mapView.removeOverlays(mapView.overlays)
            // 각 섹션마다 오버레이 추가
            for (index, sectionCoords) in sectionsCoordinates.enumerated() {
                guard sectionCoords.count >= 2 else { continue }
                let polyline = MKPolyline(coordinates: sectionCoords, count: sectionCoords.count)
                polyline.title = "전체 경로-\(index)"  // 섹션별로 구분
                sheetView.addMapOverlay(polyline)
            }
        }
        
        // MARK: - 3D 카메라 애니메이션 (섹션별)
        
        /// 현재 섹션의 애니메이션 시작
        private func startCameraAnimationForCurrentSection() {
            guard currentSectionIndex < sectionsCoordinates.count else { return }
            let sectionCoords = sectionsCoordinates[currentSectionIndex]
            guard sectionCoords.count > 1 else { return }
            
            cameraTimer?.invalidate()
            cameraTimer = nil
            currentCoordIndexInSection = 0
            
            // 초기 카메라 설정: 현재 섹션 첫 좌표, 현재 카메라 heading 유지
            setCameraToCoordinate(sectionCoords[0], heading: sheetView.mapView.camera.heading)
            
            cameraTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                               target: self,
                                               selector: #selector(updateCameraForSection),
                                               userInfo: nil,
                                               repeats: true)
        }
        
        /// 섹션 내에서 카메라를 업데이트
        @objc private func updateCameraForSection() {
            let sectionCoords = sectionsCoordinates[currentSectionIndex]
            guard currentCoordIndexInSection < sectionCoords.count - 1 else {
                // 현재 섹션의 끝에 도달하면 다음 섹션으로 전환
                moveToNextSectionIfAvailable()
                return
            }
            
            let currentCoord = sectionCoords[currentCoordIndexInSection]
            let nextCoord = sectionCoords[currentCoordIndexInSection + 1]
            
            // 경로 진행 방향에 따른 heading 계산
            let rawHeading = calculateHeading(from: currentCoord, to: nextCoord)
            // (필요 시 오프셋 적용: 예, 뒤에서 보는 시점이면 +180)
            let targetHeading = rawHeading.truncatingRemainder(dividingBy: 360)
            
            UIView.animate(withDuration: 0.2) {
                self.setCameraToCoordinate(nextCoord, heading: targetHeading)
            }
            currentCoordIndexInSection += 1
            
            updateProgressOverlayForCurrentSection()
        }
        
        /// 현재 섹션이 끝났다면 다음 섹션으로 전환 (있을 경우)
        private func moveToNextSectionIfAvailable() {
            if currentSectionIndex < sectionsCoordinates.count - 1 {
                currentSectionIndex += 1
                currentCoordIndexInSection = 0
                // 카메라를 다음 섹션의 첫 좌표로 바로 전환
                let nextSectionCoords = sectionsCoordinates[currentSectionIndex]
                if let firstCoord = nextSectionCoords.first {
                    setCameraToCoordinate(firstCoord, heading: sheetView.mapView.camera.heading)
                }
                // 새로운 섹션의 진행 오버레이는 초기화 (필요 시)
                updateProgressOverlayForCurrentSection(reset: true)
            } else {
                // 모든 섹션 완료 시 타이머 종료
                cameraTimer?.invalidate()
                cameraTimer = nil
            }
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
        
        /// 진행 경로 오버레이 업데이트 (현재 섹션만 표시)
        private func updateProgressOverlayForCurrentSection(reset: Bool = false) {
            let mapView = sheetView.mapView
            
            // 기존 진행 오버레이 제거
            if let progressOverlay = progressOverlay {
                mapView.removeOverlay(progressOverlay)
            }
            
            // 만약 reset이면 현재 섹션의 진행 경로 초기화
            let sectionCoords = sectionsCoordinates[currentSectionIndex]
            let progressCoords: [CLLocationCoordinate2D]
            if reset {
                progressCoords = []
            } else {
                progressCoords = Array(sectionCoords.prefix(currentCoordIndexInSection + 1))
            }
            
            guard progressCoords.count >= 2 else { return }
            let overlay = MKPolyline(coordinates: progressCoords, count: progressCoords.count)
            overlay.title = "진행 경로"
            progressOverlay = overlay
            sheetView.addMapOverlay(overlay)
        }
    }

    // MARK: - MKMapViewDelegate
    extension MovingTrackSheetViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline, let title = polyline.title else { return MKOverlayRenderer() }
            let renderer = MKPolylineRenderer(polyline: polyline)
            if title == "진행 경로" {
                renderer.strokeColor = .systemRed
                renderer.lineWidth = 6
            } else {
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
            }
            return renderer
        }
    }
