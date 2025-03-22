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
    
    let mediaUseCase = MediaUseCaseImpl()
    
    private var recordDetails: [RecordDetail] = []
    
    /// 각 section에 해당하는 폴리라인 배열
    private var polylineOverlays: [MKPolyline] = []
    /// 선택된 section의 인덱스 (nil이면 선택된 section 없음)
    private var selectedSectionIndex: Int? = nil
    
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
        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makePathImage()
        
    }
    
    private func makePathImage() {
        if let image = UIImage.imageFromView(view: detailLogView.mapView) {
            guard let newImage = self.cropImage(inputImage: image) else {
                print("이미지 생성 실패")
                return
            }
            do {
                try mediaUseCase.saveImageToDocuments(image: image, imageName: "test_img.png")
            } catch {
                print(error)
            }
            
        }
    }
    
    func cropImage(inputImage image: UIImage) -> UIImage? {
        let mapviewWidth = detailLogView.mapView.bounds.width
        let mapviewHeight = detailLogView.mapView.bounds.height
        
        // 이미지 크기를 확인
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        // 이미지에서 자를 영역을 설정 (mapView에서 필요한 부분만)
        let cropRect = CGRect(x: 16, y: 24, width: mapviewWidth, height: mapviewHeight)
        
        // 이미지 크기를 기준으로 크롭 영역을 조정
        let imageViewScale = max(imageWidth / mapviewWidth, imageHeight / mapviewHeight)
        
        // 크롭할 영역 계산 (이미지 크기와 맞추기 위해 스케일링)
        let cropZone = CGRect(x: cropRect.origin.x * imageViewScale,
                              y: cropRect.origin.y * imageViewScale,
                              width: cropRect.size.width * imageViewScale,
                              height: cropRect.size.height * imageViewScale)
        
        return UIImage.cropImage(image, toRect: cropZone, viewWidth: imageWidth, viewHeight: imageHeight)
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
                
                let sheetVC = MovingTrackSheetViewController(viewModel: MovingTrackSheetViewModel())
                
                if let sheet = sheetVC.sheetPresentationController {
                    let customDetent = UISheetPresentationController.Detent.custom(identifier: .init("myCustomDetent")) { _ in
                        820
                    }
                    sheet.detents = [customDetent]
                    sheet.selectedDetentIdentifier = customDetent.identifier
                    
                    // Grabber 제거
                    sheet.prefersGrabberVisible = false
                    
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    sheet.preferredCornerRadius = 16
                }
                
                sheetVC.modalPresentationStyle = .pageSheet
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
                    self.detailLogView.configure(with: DisplayDayLog(from: dayLog))
                    self.recordDetails = dayLog.sections.map {
                        RecordDetail(from: $0)
                    }
                    self.detailLogView.recordDetailView.tableView.reloadData()
                case .edit:
                    print("수정하기 탭됨 → 수정 로직")
                case .share:
                    self.handleShare(in: self, shareText: "하트런 기록 공유!")
                    
                case .delete:
                    self.handleDelete(in: self, dateString: "2024년 3월 3일")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Action Handlers (함수 분리)
    private func handleShare(in targetVC: UIViewController, shareText: String) {
        let shareItems: [Any] = [shareText]
        let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        targetVC.present(activityVC, animated: true)
    }
    
    private func handleDelete(in targetVC: UIViewController, dateString: String) {
        let alert = UIAlertController(
            title: "기록 삭제하기",
            message: "\(dateString) 기록을 정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(title: "네", style: .destructive) { _ in
            // 실제 삭제 로직 처리
            print("기록 삭제 완료 로직")
        }
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        targetVC.present(alert, animated: true)
    }
    
    private func updateNavigationTitle(with date: Date) {
        self.title = date.formattedString(.monthDay)
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
        
        // 선택된 section 인덱스 업데이트 (헤더 때문에 -1)
        selectedSectionIndex = indexPath.row - 1
        
        // 테이블뷰 리로드: 선택 상태 변경을 반영하기 위해
            tableView.reloadData()
        
        // 맵뷰 오버레이를 제거 후 다시 추가하여 렌더러가 다시 호출되도록 함
        detailLogView.removeAllMapOverlays()
        for polyline in polylineOverlays {
            detailLogView.addMapOverlay(polyline)
        }
    }
}


// MARK: - Setup MapView & 폴리라인
extension DetailLogViewController {
    
    /// 맵뷰 초기 설정(Delegate, 데이터 세팅, 폴리라인 표시 등)
    private func setupMapView() {
        // 1) 맵뷰 델리게이트 설정
        detailLogView.setMapViewDelegate(self)
        
        // 2) 데이터 세팅 (dummyDisplayLog 활용)
        detailLogView.configure(with: dummyDisplayLog)
        
        // 3) 폴리라인 그리기
        drawPolyline(from: dummyDayLog)
    }
    
    /// dummyDayLog의 모든 Section을 순회하여 폴리라인을 그리고, 적절히 확대
    private func drawPolyline(from dayLog: DayLog) {
        // 기존 오버레이 제거
        detailLogView.removeAllMapOverlays()
        polylineOverlays.removeAll()
        
        // 각 section 별로 폴리라인 생성
        for (index, section) in dayLog.sections.enumerated() {
            let coordinates = section.route.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
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
    
    
}



// MARK: - MKMapViewDelegate
extension DetailLogViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        if let title = polyline.title, let index = Int(title), index == selectedSectionIndex {
            renderer.strokeColor = .red  // 선택된 section이면 빨간색으로 표시
            renderer.lineWidth = 6
        } else {
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
        }
        return renderer
    }
}



// MARK: 더미데이터
let dummyDayLog = DayLog(
    date: Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 17)) ?? Date(),
    locationName: "광진구",
    weather: 1,
    temperature: 20,
    trackImage: Data(),
    title: "아침 달리기",
    level: 2,
    totalTime: 3600,        // 1시간
    totalDistance: 5.0,     // 5km
    totalSteps: 7000,
    sections: [
        // --- 나가는 구간 5개 ---
        Section(
            distance: 0.5,
            steps: 300,
            route: [
                Point(latitude: 37.5470, longitude: 127.0800, timestamp: Date()),
                Point(latitude: 37.5473, longitude: 127.0804, timestamp: Date().addingTimeInterval(60))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 310,
            route: [
                Point(latitude: 37.5473, longitude: 127.0804, timestamp: Date().addingTimeInterval(70)),
                Point(latitude: 37.5475, longitude: 127.0810, timestamp: Date().addingTimeInterval(130))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 320,
            route: [
                Point(latitude: 37.5475, longitude: 127.0810, timestamp: Date().addingTimeInterval(140)),
                Point(latitude: 37.5480, longitude: 127.0815, timestamp: Date().addingTimeInterval(200))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 330,
            route: [
                Point(latitude: 37.5480, longitude: 127.0815, timestamp: Date().addingTimeInterval(210)),
                Point(latitude: 37.5483, longitude: 127.0822, timestamp: Date().addingTimeInterval(270))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 340,
            route: [
                Point(latitude: 37.5483, longitude: 127.0822, timestamp: Date().addingTimeInterval(280)),
                Point(latitude: 37.5486, longitude: 127.0827, timestamp: Date().addingTimeInterval(340))
            ]
        ),
        
        // --- 돌아오는 구간 5개 ---
        Section(
            distance: 0.5,
            steps: 350,
            route: [
                Point(latitude: 37.5486, longitude: 127.0827, timestamp: Date().addingTimeInterval(350)),
                Point(latitude: 37.5483, longitude: 127.0820, timestamp: Date().addingTimeInterval(410))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 360,
            route: [
                Point(latitude: 37.5483, longitude: 127.0820, timestamp: Date().addingTimeInterval(420)),
                Point(latitude: 37.5480, longitude: 127.0813, timestamp: Date().addingTimeInterval(480))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 370,
            route: [
                Point(latitude: 37.5480, longitude: 127.0813, timestamp: Date().addingTimeInterval(490)),
                Point(latitude: 37.5476, longitude: 127.0810, timestamp: Date().addingTimeInterval(550))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 380,
            route: [
                Point(latitude: 37.5476, longitude: 127.0810, timestamp: Date().addingTimeInterval(560)),
                Point(latitude: 37.5473, longitude: 127.0806, timestamp: Date().addingTimeInterval(620))
            ]
        ),
        Section(
            distance: 0.5,
            steps: 390,
            route: [
                Point(latitude: 37.5473, longitude: 127.0806, timestamp: Date().addingTimeInterval(630)),
                Point(latitude: 37.5470, longitude: 127.0800, timestamp: Date().addingTimeInterval(690))
            ]
        )
    ]
)

// dummyDayLog를 기반으로 DisplayDayLog 생성
let dummyDisplayLog = DisplayDayLog(from: dummyDayLog)
