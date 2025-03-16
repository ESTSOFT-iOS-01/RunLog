//
//  LogView.swift
//  RunLog
//
//  Created by 도민준 on 3/17/25.
//

import UIKit
import MapKit
import SnapKit
import Then

final class LogView: UIView {
    
    // MARK: - UI Components 선언
    
    /// 전체 스크롤 뷰 (콘텐츠 전체를 스크롤하기 위한 컨테이너)
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    /// 스크롤뷰 내부 컨텐츠를 담는 뷰
    private let contentView = UIView().then { _ in }
    
    /// 지도 영역을 표시하는 MKMapView
    private let mapView = MKMapView().then {
        // 추가 delegate 설정 및 커스터마이징 가능
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    /// 지도 위에 오버레이될 무빙트랙 버튼
    private let movingTrackButton = UIButton(type: .system).then {
        // 이거 수정 필요
        let attributedTitle = NSAttributedString.RLAttributedString(text: "   무빙트랙", font: .Label2, color: .Gray000)
        $0.setAttributedTitle(attributedTitle, for: .normal)
        $0.backgroundColor = .Gray300
        $0.layer.cornerRadius = 10
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        let icon = UIImage(systemName: RLIcon.play.name)?.withConfiguration(config)
        $0.setImage(icon, for: .normal)
        $0.tintColor = .Gray000
        
        $0.addTarget(LogView.self, action: #selector(movingTrackButtonTapped), for: .touchUpInside)
    }
    
    
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
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 콘텐츠 영역에 지도와 상세 기록 헤더 추가
        contentView.addSubview(mapView)
        mapView.addSubview(movingTrackButton)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(mapView.snp.width)
        }
        
        movingTrackButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
    
    // MARK: - Actions
    @objc private func movingTrackButtonTapped() {
        print("무빙트랙 버튼 탭됨")
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct LogView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            LogView()
        }
        .previewLayout(.sizeThatFits) // 크기를 적절하게 조절하여 미리보기 가능
        .padding()
    }
}

// UIKit 뷰를 SwiftUI에서 렌더링하는 Helper
struct UIViewPreview<T: UIView>: UIViewRepresentable {
    let viewBuilder: () -> T
    
    init(_ viewBuilder: @escaping () -> T) {
        self.viewBuilder = viewBuilder
    }
    
    func makeUIView(context: Context) -> T {
        return viewBuilder()
    }
    
    func updateUIView(_ uiView: T, context: Context) {}
}
#endif
