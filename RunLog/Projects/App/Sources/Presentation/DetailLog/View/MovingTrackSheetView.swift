//
//  MovingTrackSheetView.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//
import RLDesignSystem
import RLUtil

import UIKit
import MapKit
import SnapKit
import Then

final class MovingTrackSheetView: UIView {
    
    // MARK: - UI Components 선언
    private let dateLabel = RLLabel(
        text: "날짜",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    private let subtitleLabel = RLLabel(
        text: "이날의 동선을 영상으로 확인해 보세요!",
        textColor: .Gray100,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    let mapView = MKMapView().then {
        // 추가 delegate 설정 및 커스터마이징 가능
        $0.layer.cornerRadius = DynamicSize.scaledSize(16)
        $0.clipsToBounds = true
    }
    

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        backgroundColor = .Gray700
        
        self.addSubviews(dateLabel, subtitleLabel, closeButton, mapView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        // 상단 날짜 라벨
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(48))
            make.centerX.equalToSuperview()
        }
        
        // 닫기 버튼
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(DynamicSize.scaledSize(32))
        }
        
        // 서브타이틀
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(DynamicSize.scaledSize(4))
            make.centerX.equalToSuperview()
        }
        
        // 지도
        mapView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(DynamicSize.scaledSize(48))
            make.leading.trailing.equalToSuperview().inset(DynamicSize.scaledSize(24))
            make.height.equalTo(mapView.snp.width).multipliedBy(498.0 / 392.0)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(-60))
        }
        
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}

extension MovingTrackSheetView {
    /// 날짜를 받아서 dateLabel에 반영
    func configure(with date: Date) {
        let dateString = date.formattedString(.detailedFull)
        print("MovingTrackSheetView configure 호출됨, 날짜: \(dateString)")
        dateLabel.label.text = dateString
    }
}

extension MovingTrackSheetView {
    
    // 메서드: MapOverlay 추가
    func addMapOverlay(_ overlay: MKOverlay) {
        mapView.addOverlay(overlay)
    }
    
    // 메서드: 맵 영역 설정
    func setMapRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }
}
