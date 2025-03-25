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
        let tableView = detailLogView.recordDetailView.tableView
        tableView.dataSource = self
        tableView.delegate = self
        setupUI()
        setupNavigationBar()
        bindGesture()
        bindViewModel()
        // setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshDayLog()
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
    }
    
    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        // 네비게이션바 디테일 설정
        navigationController?.setupAppearance() // 스타일 설정
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
    private func bindGesture() {
        // 제스처 추가
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
                    
                    // Grabber 제거
                    sheet.prefersGrabberVisible = false
                    
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    sheet.preferredCornerRadius = DynamicSize.scaledSize(16)
                }
                
                
                self.present(sheetVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self, let output = output else { return }
                switch output {
                case .loadedDayLog(let dayLog):
                    self.currentDayLog = dayLog
                    
                    self.detailLogView.configure(with: DisplayDayLog(from: dayLog))
                    self.recordDetails = dayLog.sections.map {
                        RecordDetail(from: $0)
                    }
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
    private func handleShare() {
        guard let data = currentDayLog?.trackImage else { return }
        let shareItems: [Any] = [UIImage(data: data)!]
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
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
                    // 삭제 성공 후 이전 화면으로 돌아가거나 추가 작업 수행
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
    
    
    private func updateNavigationTitle(with date: Date) {
        self.title = date.formattedString(.monthDay)
    }
    
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
    
    // 헤더 행 1개 + 실제 데이터 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDetails.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            // 헤더 셀
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecordDetailViewCell.identifier,
                for: indexPath
            ) as? RecordDetailViewCell else {
                return UITableViewCell()
            }
            cell.configureAsHeader()
            //print("디버그: 헤더 셀 생성됨, 시각: \(Date())")
            return cell
        } else {
            let record = recordDetails[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: RecordDetailViewCell.identifier,
                for: indexPath
            ) as? RecordDetailViewCell else {
                return UITableViewCell()
            }
            // 선택된 셀이면 폰트를 RLHeadline1, 아니면 RLHeadline2로 설정
            if indexPath.row - 1 == selectedSectionIndex {
                cell.configure(with: record, font: .RLHeadline1)
            } else {
                cell.configure(with: record, font: .RLHeadline2)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 헤더 셀은 무시 (indexPath.row == 0)
        guard indexPath.row > 0 else { return }
        
        let newSelectionIndex = indexPath.row - 1
        // 이전 선택값을 임시 변수에 저장
        let previousSelection = selectedSectionIndex
        
        // 즉시 선택된 셀 색상 변경
        selectedSectionIndex = newSelectionIndex
        tableView.reloadData()
        
        // 맵 오버레이 업데이트
        detailLogView.removeAllMapOverlays()
        for polyline in polylineOverlays {
            detailLogView.addMapOverlay(polyline)
        }
        
        // 만약 이미 선택된 섹션이 있고, 다른 셀을 선택한 경우
        if let previous = previousSelection, previous != newSelectionIndex {
            // 기존 선택 해제 후 전체 경로로 줌 처리
            selectedSectionIndex = nil
            tableView.reloadData()
            if let dayLog = currentDayLog {
                zoomToAllPoints(dayLog: dayLog)
            }
            
            // 약간의 딜레이 후 새 선택 섹션 줌 처리
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.selectedSectionIndex = newSelectionIndex
                tableView.reloadData()
                if let dayLog = self.currentDayLog,
                   dayLog.sections.indices.contains(newSelectionIndex) {
                    let selectedSection = dayLog.sections[newSelectionIndex]
                    self.zoomToRoute(route: selectedSection.route)
                }
            }
        } else {
            // 처음 선택하거나 동일한 셀 재선택인 경우 바로 줌 처리
            if let dayLog = currentDayLog, dayLog.sections.indices.contains(newSelectionIndex) {
                let selectedSection = dayLog.sections[newSelectionIndex]
                zoomToRoute(route: selectedSection.route)
            }
        }
    }
    
}


// MARK: - Setup MapView & 폴리라인
extension DetailLogViewController {
    
    /// DayLog를 파라미터로 받아 맵뷰 초기설정 및 폴리라인 그리기
    private func setupMapView(with dayLog: DayLog) {
        // 1) 맵뷰 델리게이트 설정
        detailLogView.setMapViewDelegate(self)
        // 2) 데이터 세팅 (DisplayDayLog 생성 대신, dayLog 데이터 활용)
        detailLogView.configure(with: DisplayDayLog(from: dayLog))
        // 3) 폴리라인 그리기
        drawPolyline(from: dayLog)
    }
    
    /// dummyDayLog의 모든 Section을 순회하여 폴리라인을 그리고, 적절히 확대
    private func drawPolyline(from dayLog: DayLog) {
        // 기존 오버레이 제거
        detailLogView.removeAllMapOverlays()
        polylineOverlays.removeAll()
        
        // 각 section 별로 폴리라인 생성
        for (index, section) in dayLog.sections.enumerated() {
            // timestamp 기준으로 정렬한 후 좌표 배열 생성
            let sortedCoordinates = section.route
                .sorted(by: { $0.timestamp < $1.timestamp })
                .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            
            guard sortedCoordinates.count >= 2 else { continue }
            
            let polyline = MKPolyline(coordinates: sortedCoordinates, count: sortedCoordinates.count)
            polyline.title = "\(index)"  // section 인덱스를 문자열로 저장
            polylineOverlays.append(polyline)
            detailLogView.addMapOverlay(polyline)
        }
        
        // 전체 영역이 보이도록 확대
        zoomToAllPoints(dayLog: dayLog)
        
    }
    
    /// 모든 경로 점들을 순회하여 바운딩 박스(최소·최대 위도/경도) 구하기
    private func zoomToAllPoints(dayLog: DayLog) {
        // 1) 모든 Point 추출
        let allPoints = dayLog.sections.flatMap { $0.route }
        guard !allPoints.isEmpty else { return }
        
        // 2) min/max lat, lon 구하기
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
        
        // 3) 중심좌표 = (minLat ~ maxLat)의 중앙, (minLon ~ maxLon)의 중앙
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        
        // 4) 가장 멀리 떨어진 두 점 = (minLat, minLon) vs (maxLat, maxLon) 라고 가정
        let corner1 = CLLocation(latitude: minLat, longitude: minLon)
        let corner2 = CLLocation(latitude: maxLat, longitude: maxLon)
        
        // 5) 두 지점 사이의 거리(미터)
        var distance = corner1.distance(from: corner2)
        // 거리에 여유를 주고 싶다면 1.2배 등 곱해주기
        if distance == 0 {
            distance = 5000
        } else {
            distance *= 1.2
        }
        
        // 6) region 설정
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: distance,
            longitudinalMeters: distance
        )
        
        detailLogView.setMapRegion(region, animated: true)
    }
    
    private func zoomToRoute(route: [Point]) {
        // 경로가 비어있으면 아무 작업도 하지 않음
        guard !route.isEmpty else { return }
        
        var minLat = Double.greatestFiniteMagnitude
        var maxLat = -Double.greatestFiniteMagnitude
        var minLon = Double.greatestFiniteMagnitude
        var maxLon = -Double.greatestFiniteMagnitude
        
        // 각 좌표의 최소, 최대 위도/경도 계산
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
        
        // 두 모서리 좌표 사이의 거리 계산 (여유를 위해 1.2배)
        let corner1 = CLLocation(latitude: minLat, longitude: minLon)
        let corner2 = CLLocation(latitude: maxLat, longitude: maxLon)
        var distance = corner1.distance(from: corner2)
        distance = (distance == 0) ? 5000 : distance * 1.2
        
        // MKCoordinateRegion 생성 후 맵뷰 영역 설정
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
            renderer.strokeColor = .NormalGreen  // 선택된 section이면 NormalGreen색으로 표시
            renderer.lineWidth = 6
        } else {
            renderer.strokeColor = .LightGreen
            renderer.lineWidth = 5
        }
        return renderer
    }
}


