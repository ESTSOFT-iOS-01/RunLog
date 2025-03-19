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
    private let dateLabel = RLLabel(
        text: "2025년 3월 3일 수요일",
        textColor: .Gray000,
        icon: nil,
        align: .left,
        font: .RLHeading1
    )
    
    private let subtitleLabel = RLLabel(
        text: "이날의 동선을 영상으로 간직하고 공유해 보세요!",
        textColor: .Gray100,
        icon: nil,
        align: .left,
        font: .RLBody1
    )
    
    let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    private let mapView = MKMapView().then {
        // 추가 delegate 설정 및 커스터마이징 가능
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    let saveButton = RLButton(title: "라이브러리에 저장하기", titleColor: .Gray900).then {
        $0.configureBackgroundColor(.LightGreen)
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
        
        self.addSubviews(dateLabel, subtitleLabel, closeButton, mapView, saveButton)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        // 상단 날짜 라벨
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(48)
                make.centerX.equalToSuperview()
        }
        
        // 닫기 버튼
        closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(32)
        }
        
        // 서브타이틀
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        // 지도
        mapView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(mapView.snp.width).multipliedBy(498.0 / 392.0)
        }
        
        // 저장하기 버튼
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(52)
            make.height.equalTo(63)
            // 바텀 마진
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-60)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct MypageProfileView_Preview: PreviewProvider {
//    static var previews: some View {
//        UIViewPreview {
//            MovingTrackSheetView()
//        }
//        .previewLayout(.sizeThatFits) // 크기를 적절하게 조절하여 미리보기 가능
//        .padding()
//    }
//}
//
//
//#endif
