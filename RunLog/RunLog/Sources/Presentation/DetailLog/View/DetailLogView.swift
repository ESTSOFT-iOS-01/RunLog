//
//  DetailLogView.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import MapKit
import SnapKit
import Then


final class DetailLogView: UIView {
    
    // MARK: - UI Components 선언
    
    /// 전체 스크롤 뷰 (콘텐츠 전체를 스크롤하기 위한 컨테이너)
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    /// 스크롤뷰 내부 컨텐츠를 담는 뷰
    let contentView = UIView().then { _ in }
    
    /// 지도 영역을 표시하는 MKMapView
    private let mapView = MKMapView().then {
        // 추가 delegate 설정 및 커스터마이징 가능
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    
    
    /// 지도 위에 오버레이될 무빙트랙 버튼
    let movingTrackButton = UIButton(type: .system).then {
        $0.configuration = UIButton.Configuration.plain()
        
        let attributedTitle = NSAttributedString.RLAttributedString(text: "무빙트랙", font: .Label2)
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.backgroundColor = .Gray300
        $0.layer.cornerRadius = 10
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let icon = UIImage(systemName: RLIcon.play.name)?.withConfiguration(config)
        $0.setImage(icon, for: .normal)
        $0.tintColor = .Gray000
        
        $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        $0.configuration?.imagePadding = 8
    }
    
    
    
    /// 타이틀 라벨
    private let titleLabel = RLLabel(
        text: "하트런",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLDetailTitle,
        tintColor: .Gray000
    )
    
    /// 날씨/지역 라벨들
    private let locationLabel = RLLabel(
        text: "서울특별시",
        textColor: .Gray100,
        icon: UIImage(systemName: RLIcon.mappin.name),
        align: .left,
        font: .RLLabel2,
        tintColor: .Gray100
    )
    private let weatherLabel = RLLabel(
        text: "흐림 | 12°C",
        textColor: .Gray100,
        icon: UIImage(systemName: RLIcon.weather.name),
        align: .left,
        font: .RLLabel2,
        tintColor: .Gray100
    )
    private let conditionLabel = RLLabel(
        text: "어려움",
        textColor: .Gray100,
        icon: UIImage(systemName: RLIcon.dumbell.name),
        align: .left,
        font: .RLLabel2,
        tintColor: .Gray100
    )
    
    /// 날씨 라벨들을 묶는 수평 스택뷰
    private lazy var weatherStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [locationLabel, weatherLabel, conditionLabel])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    /// 구분선
    private let separatorView = UIView().then {
        $0.backgroundColor = .Gray000  // 원하는 색상
    }
    
    private let timeTitleLabel = RLLabel(
        text: "소요시간",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    private let timeValueLabel = RLLabel(
        text: "24시간 23분",
        textColor: .LightOrange,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    private lazy var timeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeTitleLabel, timeValueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private let distanceTitleLabel = RLLabel(
        text: "운동거리",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    private let distanceValueLabel = RLLabel(
        text: "999.99km",
        textColor: .LightPink,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    private lazy var distanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [distanceTitleLabel, distanceValueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private let stepsTitleLabel = RLLabel(
        text: "걸음수",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    private let stepsValueLabel = RLLabel(
        text: "2,237,345",
        textColor: .LightBlue,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    private lazy var stepsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stepsTitleLabel, stepsValueLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()
    
    private lazy var statsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeStack, distanceStack, stepsStack])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 0
        stack.distribution = .fill
        return stack
    }()
    
    let recordTitleLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(text: "기록 상세", font: .Heading1)
    }
    
    // 테이블뷰를 담은 뷰
    let recordDetailView = RecordDetailView()
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        
        print("LogView initialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        backgroundColor = .Gray900
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(mapView, titleLabel, weatherStack, separatorView, statsStack, recordTitleLabel, recordDetailView)
        mapView.addSubview(movingTrackButton)
        
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self.safeAreaLayoutGuide.snp.width)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(mapView.snp.width)
        }
        
        movingTrackButton.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(8)
            make.width.equalTo(95)
            make.height.equalTo(40)
        }
        
        // 타이틀 라벨: 맵뷰 아래
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        // 날씨 스택: 타이틀 아래
        weatherStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(24)
        }
        
        // 구분선:날씨 스택 아래
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(weatherStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(1)
        }
        
        // 통계 스택: 구분선 아래
        statsStack.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        timeStack.snp.makeConstraints { make in
            make.width.equalTo(statsStack.snp.width).multipliedBy(0.334)
        }
        distanceStack.snp.makeConstraints { make in
            make.width.equalTo(statsStack.snp.width).multipliedBy(0.333)
        }
        stepsStack.snp.makeConstraints { make in
            make.width.equalTo(statsStack.snp.width).multipliedBy(0.333)
        }
        
        // 기록상세
        recordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(statsStack.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(24)
        }
        
        // “기록 상세” 테이블뷰
        recordDetailView.snp.makeConstraints { make in
            make.top.equalTo(recordTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}

// MARK: - Configure Extension
extension DetailLogView {
    /// DisplayDayLog 데이터를 기반으로 UI를 업데이트하는 메서드
    func configure(with log: DisplayDayLog) {
        // 타이틀 업데이트
        titleLabel.label.text = log.title
        
        // 위치 업데이트
        locationLabel.label.text = log.locationName
        
        // 날씨 업데이트 (예: "맑음 | 20°C")
        weatherLabel.label.text = "\(log.weather) | \(log.temperature)°C"
        
        // 난이도 업데이트
        conditionLabel.label.text = log.level
        
        // 소요시간 업데이트 (예: "1시간 0분")
        timeValueLabel.label.text = log.totalTime.hourMinuteString
        
        // 운동거리 업데이트 (예: "5.0km")
        distanceValueLabel.label.text = "\(log.totalDistance)km"
        
        // 걸음수 업데이트 (천 단위 구분 기호 포함)
        stepsValueLabel.label.text = log.totalSteps.formattedString
    }
    
}

extension DetailLogView {
    // MARK: - MapView Helper Methods
    /// 외부에서 MKMapViewDelegate를 주입하기 위한 헬퍼 메서드
    func setMapViewDelegate(_ delegate: MKMapViewDelegate) {
        mapView.delegate = delegate
    }
    
    /// 폴리라인 등의 오버레이를 추가
    func addMapOverlay(_ overlay: MKOverlay) {
        mapView.addOverlay(overlay)
    }
    
    /// 맵뷰 영역 설정
    func setMapRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }
    
    func removeAllMapOverlays() {
        mapView.removeOverlays(mapView.overlays)
    }
}


