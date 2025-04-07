//
//  MovingTrackSheetView.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import MapKit
import SnapKit
import Then

final class MovingTrackSheetView: UIView {
    
    // MARK: - UI Components 선언
    /// 날짜를 표시하는 라벨
    private let dateLabel = RLLabel(
        text: "날짜",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    /// 서브타이틀을 표시하는 라벨
    private let subtitleLabel = RLLabel(
        text: "이날의 동선을 영상으로 확인해 보세요!",
        textColor: .Gray100,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    /// 닫기 버튼 (뷰를 종료하기 위한 버튼)
    let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    /// 지도 영역을 표시하는 MKMapView
    let mapView = MKMapView().then {
        // 지도에 둥근 모서리 효과 적용 및 클리핑 활성화
        $0.layer.cornerRadius = DynamicSize.scaledSize(16)
        $0.clipsToBounds = true
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()      // UI 요소 추가
        setupLayout()  // SnapKit 레이아웃 제약조건 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    /// 하위 뷰들을 추가하고 기본 배경색을 설정하는 메서드
    private func setupUI() {
        backgroundColor = .Gray700
        self.addSubviews(dateLabel, subtitleLabel, closeButton, mapView)
    }
    
    // MARK: - Setup Layout
    /// SnapKit을 사용하여 UI 요소들의 레이아웃을 설정하는 메서드
    private func setupLayout() {
        // 날짜 라벨: safeArea 상단에서 일정 간격 떨어져 중앙에 위치
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(48))
            make.centerX.equalToSuperview()
        }
        
        // 닫기 버튼: 날짜 라벨의 수평 중앙에 맞추고, 오른쪽에 인셋 적용
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(DynamicSize.scaledSize(32))
        }
        
        // 서브타이틀: 날짜 라벨 아래에 위치하며 중앙 정렬
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(DynamicSize.scaledSize(4))
            make.centerX.equalToSuperview()
        }
        
        // 지도: 서브타이틀 아래에서 시작, 좌우 인셋 적용, 높이는 너비 비율에 따라 설정하고 safeArea 하단에 여백 적용
        mapView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(DynamicSize.scaledSize(48))
            make.leading.trailing.equalToSuperview().inset(DynamicSize.scaledSize(24))
            make.height.equalTo(mapView.snp.width).multipliedBy(498.0 / 392.0)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(-60))
        }
    }
    
    // MARK: - Configure
    /// 추가적인 뷰 설정을 위한 메서드 (필요 시 구현)
    private func configure() {
        // 추가 설정이 필요하면 여기에 작성
    }
}

extension MovingTrackSheetView {
    /// 날짜를 받아 dateLabel에 반영하는 메서드
    func configure(with date: Date) {
        let dateString = date.formattedString(.detailedFull)
        print("MovingTrackSheetView configure 호출됨, 날짜: \(dateString)")
        dateLabel.label.text = dateString
    }
}

extension MovingTrackSheetView {
    
    /// MapView에 오버레이를 추가하는 메서드
    func addMapOverlay(_ overlay: MKOverlay) {
        mapView.addOverlay(overlay)
    }
    
    /// MapView의 영역을 설정하는 메서드
    func setMapRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }
}
