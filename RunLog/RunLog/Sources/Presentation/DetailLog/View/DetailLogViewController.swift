//
//  DetailLogViewController.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import SnapKit
import Then
import Combine
import MapKit

final class DetailLogViewController: UIViewController {
    
    // MARK: - DI
    private let viewModel: DetailLogViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var recordDetails: [RecordDetail] = []
    
    /// 각 section에 해당하는 폴리라인 배열
    private var polylineOverlays: [MKPolyline] = []
    /// 선택된 section의 인덱스 (nil이면 선택된 section 없음)
    private var selectedSectionIndex: Int? = nil
    
    private var currentDayLog: DayLog?
    
    // MARK: - UI
    /// 전체 화면을 구성하는 뷰 (스크롤뷰 포함)
    private let detailLogView = DetailLogView()
    
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
        detailLogView.frame = UIScreen.main.bounds
        self.view = detailLogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("디버그: viewDidLoad 호출됨, 시각: \(Date())")
        
        // 테이블뷰의 데이터소스와 delegate 설정
        let tableView = detailLogView.recordDetailView.tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        setupUI()
        setupNavigationBar()
        bindGesture()
        bindViewModel()
        // setupMapView() // 초기 맵뷰 설정은 뷰모델 바인딩 내에서 처리
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰모델을 통해 DayLog 데이터를 새로고침하고 UI 업데이트
        viewModel.refreshDayLog()
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup UI
    /// 추가적인 UI 설정이 필요할 경우 여기에 구현 (현재는 기본 설정만 적용)
    private func setupUI() {
        // UI 요소 추가 시 필요한 설정을 여기에 작성
    }
    
    // MARK: - Setup Navigation Bar
    /// 네비게이션 바 스타일 및 오른쪽 메뉴 버튼 추가 설정
    private func setupNavigationBar() {
        navigationController?.setupAppearance() // 네비게이션 바 스타일 적용
        navigationController?.navigationItem.backButtonTitle = "chevron.left"
        
        navigationController?
            .addRightMenuButton(menuItems: [
                ("수정하기", .init()),
                ("공유하기", .init()),
                ("삭제하기", .destructive)
            ])
            .sink { [weak self] selectedTitle in
                self?.viewModel.input.send(.menuSelected(selectedTitle))
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Gesture
    /// 무빙트랙 버튼 및 통계 스택의 제스처를 바인딩하는 메서드
    private func bindGesture() {
        // 무빙트랙 버튼 터치 시 시트형태의 화면 표시
        detailLogView.movingTrackButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let sheetViewModel = DetailLogViewModel(date: self.viewModel.date)
                let sheetVC = MovingTrackSheetViewController(viewModel: sheetViewModel)
                sheetVC.modalPresentationStyle = .pageSheet
                if let sheet = sheetVC.sheetPresentationController {
                    let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("myCustomDetent")) { _ in
                        DynamicSize.scaledSize(712)
                    }
                    sheet.detents = [customDetent]
                    sheet.selectedDetentIdentifier = customDetent.identifier
                    
                    // Grabber 비표시 설정 및 기타 시트 옵션 적용
                    sheet.prefersGrabberVisible = false
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    sheet.preferredCornerRadius = DynamicSize.scaledSize(16)
                }
                
                self.present(sheetVC, animated: true)
            }
            .store(in: &cancellables)
        
        // 통계 스택 탭 시 전체 경로를 보여주기 위해 맵 뷰를 줌 아웃
        let statsTapGesture = UITapGestureRecognizer()
        detailLogView.statsStack.addGestureRecognizer(statsTapGesture)
        
        statsTapGesture.tapPublisher
            .sink { [weak self] _ in
                guard let self = self, let dayLog = self.currentDayLog else { return }
                self.zoomToAllPoints(dayLog: dayLog)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Bind ViewModel
    /// 뷰모델의 output 이벤트를 수신하여 UI를 업데이트하고 필요한 액션을 수행하는 메서드
    private func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self, let output = output else { return }
                switch output {
                case .loadedDayLog(let dayLog):
                    self.currentDayLog = dayLog
                    
                    // 각 섹션의 첫 timestamp 기준으로 내림차순 정렬
                    let sortedSections = dayLog.sections.sorted { lhsSection, rhsSection in
                        let lhsStartTime = lhsSection.route.sorted { $0.timestamp < $1.timestamp }
                            .first?.timestamp ?? Date.distantPast
                        let rhsStartTime = rhsSection.route.sorted { $0.timestamp < $1.timestamp }
                            .first?.timestamp ?? Date.distantPast
                        return lhsStartTime > rhsStartTime
                    }
                    
                    self.recordDetails = sortedSections.map { RecordDetail(from: $0) }
                    
                    // DayLog 데이터를 기반으로 뷰 업데이트
                    self.detailLogView.configure(with: DisplayDayLog(from: dayLog))
                    self.recordDetails = dayLog.sections.map { RecordDetail(from: $0) }
                    self.detailLogView.recordDetailView.tableView.reloadData()
                    self.setupMapView(with: dayLog)
                    
                case .edit:
                    let editViewModel = EditLogInfoViewModel(date: viewModel.date)
                    self.navigationController?.pushViewController(EditLogInfoViewController(viewModel: editViewModel), animated: true)
                    
                case .share:
                    self.handleShare()
                    
                case .delete:
                    if let log = self.currentDayLog {
                        let dateString = log.date.formattedString(.detailedFull)
                        self.handleDelete(in: self, dateString: dateString)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action Handlers (함수 분리)
    /// 공유 액션 처리: 현재 DayLog의 트랙 이미지를 공유
    private func handleShare() {
        guard let data = currentDayLog?.trackImage else { return }
        let shareItems: [Any] = [UIImage(data: data)!]
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
    /// 삭제 액션 처리: 삭제 확인 Alert 후 삭제 처리
    private func handleDelete(in targetVC: UIViewController, dateString: String) {
        let alert = UIAlertController(
            title: "기록 삭제하기",
            message: "\(dateString) 기록을 정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "네", style: .destructive) { _ in
            Task {
                do {
                    try await self.viewModel.deleteDayLog()
                    // 삭제 성공 후 이전 화면으로 이동
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch {
                    // 삭제 실패 시 에러 Alert 표시
                    DispatchQueue.main.async {
                        let errorAlert = UIAlertController(
                            title: "삭제 실패",
                            message: "삭제 도중 오류가 발생했습니다.",
                            preferredStyle: .alert
                        )
                        errorAlert.addAction(UIAlertAction(title: "확인", style: .default))
                        targetVC.present(errorAlert, animated: true)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        targetVC.present(alert, animated: true)
    }
    
    /// 네비게이션 타이틀을 날짜 정보로 업데이트
    private func updateNavigationTitle(with date: Date) {
        self.title = date.formattedString(.monthDay)
    }
    
    /// 현재 DayLog 데이터를 기반으로 전체 UI를 새로고침
    private func refreshUI() {
        guard let dayLog = currentDayLog else { return }
        detailLogView.configure(with: DisplayDayLog(from: dayLog))
        recordDetails = dayLog.sections.map { RecordDetail(from: $0) }
        detailLogView.recordDetailView.tableView.reloadData()
        setupMapView(with: dayLog)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailLogViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 실제 데이터 행 수만 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDetails.count
    }
    
    // 섹션 헤더 뷰 반환
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RecordDetailHeaderView.identifier
        ) as? RecordDetailHeaderView else {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = recordDetails[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordDetailViewCell.identifier,
            for: indexPath
        ) as? RecordDetailViewCell else {
            return UITableViewCell()
        }
        // 선택된 셀은 폰트를 RLHeadline1, 그 외는 RLHeadline2로 설정
        if indexPath.row == selectedSectionIndex {
            cell.configure(with: record, font: .RLHeadline1)
        } else {
            cell.configure(with: record, font: .RLHeadline2)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectionIndex = indexPath.row
        let previousSelection = selectedSectionIndex
        
        if let previous = previousSelection, previous != newSelectionIndex {
            // 다른 셀 선택 시: 이전 선택 해제 후 전체 경로 줌(줌 아웃)
            selectedSectionIndex = nil
            tableView.reloadData()
            
            // 줌 아웃 전 오버레이 업데이트
            detailLogView.removeAllMapOverlays()
            for polyline in polylineOverlays {
                detailLogView.addMapOverlay(polyline)
            }
            
            if let dayLog = currentDayLog {
                zoomToAllPoints(dayLog: dayLog)
            }
            
            // 약간의 딜레이 후 새 선택 셀 줌(줌 인)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.selectedSectionIndex = newSelectionIndex
                tableView.reloadData()
                
                // 줌 인 전 오버레이 업데이트
                self.detailLogView.removeAllMapOverlays()
                for polyline in self.polylineOverlays {
                    self.detailLogView.addMapOverlay(polyline)
                }
                
                if let dayLog = self.currentDayLog,
                   dayLog.sections.indices.contains(newSelectionIndex) {
                    let selectedSection = dayLog.sections[newSelectionIndex]
                    self.zoomToRoute(route: selectedSection.route)
                }
            }
        } else {
            // 동일 셀 선택 시: 즉시 줌 처리
            selectedSectionIndex = newSelectionIndex
            tableView.reloadData()
            
            // 줌 처리 전 오버레이 업데이트
            detailLogView.removeAllMapOverlays()
            for polyline in polylineOverlays {
                detailLogView.addMapOverlay(polyline)
            }
            
            if let dayLog = currentDayLog,
               dayLog.sections.indices.contains(newSelectionIndex) {
                let selectedSection = dayLog.sections[newSelectionIndex]
                zoomToRoute(route: selectedSection.route)
            }
        }
    }
}

// MARK: - Setup MapView & 폴리라인
extension DetailLogViewController {
    
    /// DayLog를 기반으로 맵뷰 초기 설정 및 폴리라인 그리기
    private func setupMapView(with dayLog: DayLog) {
        // 1) 맵뷰 델리게이트 설정
        detailLogView.setMapViewDelegate(self)
        // 2) DayLog 데이터를 기반으로 뷰 업데이트
        detailLogView.configure(with: DisplayDayLog(from: dayLog))
        // 3) 폴리라인 그리기
        drawPolyline(from: dayLog)
    }
    
    /// 모든 섹션의 좌표를 순회하여 폴리라인을 그리고 전체 영역으로 줌 아웃 처리
    private func drawPolyline(from dayLog: DayLog) {
        // 기존 오버레이 제거
        detailLogView.removeAllMapOverlays()
        polylineOverlays.removeAll()
        
        // 각 섹션별 폴리라인 생성
        for (index, section) in dayLog.sections.enumerated() {
            let sortedCoordinates = section.route
                .sorted(by: { $0.timestamp < $1.timestamp })
                .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            
            guard sortedCoordinates.count >= 2 else { continue }
            
            let polyline = MKPolyline(coordinates: sortedCoordinates, count: sortedCoordinates.count)
            polyline.title = "\(index)"  // section 인덱스를 문자열로 저장
            polylineOverlays.append(polyline)
            detailLogView.addMapOverlay(polyline)
        }
        
        // 전체 경로가 보이도록 맵 뷰 줌 아웃 처리
        zoomToAllPoints(dayLog: dayLog)
    }
    
    /// 모든 좌표를 순회하여 바운딩 박스를 계산하고, 전체 영역으로 줌 아웃
    private func zoomToAllPoints(dayLog: DayLog) {
        let allPoints = dayLog.sections.flatMap { $0.route }
        guard !allPoints.isEmpty else { return }
        
        // 최소/최대 위도 및 경도 계산
        var minLat = Double.greatestFiniteMagnitude
        var maxLat = -Double.greatestFiniteMagnitude
        var minLon = Double.greatestFiniteMagnitude
        var maxLon = -Double.greatestFiniteMagnitude
        
        for point in allPoints {
            minLat = min(minLat, point.latitude)
            maxLat = max(maxLat, point.latitude)
            minLon = min(minLon, point.longitude)
            maxLon = max(maxLon, point.longitude)
        }
        
        // 중심 좌표 계산
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        
        // 두 모서리 좌표 사이의 거리 계산 (여유 1.2배 적용)
        let corner1 = CLLocation(latitude: minLat, longitude: minLon)
        let corner2 = CLLocation(latitude: maxLat, longitude: maxLon)
        var distance = corner1.distance(from: corner2)
        distance = (distance == 0) ? 5000 : distance * 1.2
        
        // MKCoordinateRegion 생성 후 맵 영역 설정
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: distance,
            longitudinalMeters: distance
        )
        
        detailLogView.setMapRegion(region, animated: true)
    }
    
    /// 선택된 섹션의 좌표를 기반으로 지도 영역을 줌 인
    private func zoomToRoute(route: [Point]) {
        guard !route.isEmpty else { return }
        
        var minLat = Double.greatestFiniteMagnitude
        var maxLat = -Double.greatestFiniteMagnitude
        var minLon = Double.greatestFiniteMagnitude
        var maxLon = -Double.greatestFiniteMagnitude
        
        // 각 좌표의 최소, 최대 위도 및 경도 계산
        for point in route {
            minLat = min(minLat, point.latitude)
            maxLat = max(maxLat, point.latitude)
            minLon = min(minLon, point.longitude)
            maxLon = max(maxLon, point.longitude)
        }
        
        // 중심 좌표 계산
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        
        // 두 모서리 좌표 사이의 거리 계산 (여유 1.2배 적용)
        let corner1 = CLLocation(latitude: minLat, longitude: minLon)
        let corner2 = CLLocation(latitude: maxLat, longitude: maxLon)
        var distance = corner1.distance(from: corner2)
        distance = (distance == 0) ? 5000 : distance * 1.2
        
        // MKCoordinateRegion 생성 후 맵 영역 설정
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: distance,
                                        longitudinalMeters: distance)
        detailLogView.setMapRegion(region, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension DetailLogViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        if let title = polyline.title, let index = Int(title), index == selectedSectionIndex {
            renderer.strokeColor = .NormalGreen  // 선택된 섹션이면 NormalGreen 색상 적용
            renderer.lineWidth = 6
        } else {
            renderer.strokeColor = .LightGreen
            renderer.lineWidth = 5
        }
        return renderer
    }
}
