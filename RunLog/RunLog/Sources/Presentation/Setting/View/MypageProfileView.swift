//
//  MypageProfileView.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then

final class MypageProfileView: UIView {
    public var nickname: String
    public var totalDistance: Double
    public var logCount: Int
    public var streakCount: Int
    
    // MARK: - UI Components 선언
    lazy var nameLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.attributedText = .RLAttributedString(text: "\(nickname) 님", font: .Title, color: .Gray000)
    }
    
    lazy var despLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        
        let totalDistanceString = totalDistance.toString(withDecimal: 1)
        let fullText = "지금까지 총 \(totalDistanceString)km를 걸으셨어요!"
        
        $0.attributedText = fullText.styledText(
            highlightText: totalDistanceString,
            baseFont: .RLHeadline2,
            baseColor: .Gray000,
            highlightFont: .RLHeadline3,
            highlightColor: .LightPink
        )
    }
    
    lazy var logCard = ProfileCardView(property: .logCount, value: logCount)
    lazy var streakCard = ProfileCardView(property: .streak, value: streakCount)
    
    lazy var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logCard, streakCard])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    // MARK: - Init
    init(nickname: String = "사용자", totalDistance: Double = 0.0, logCount: Int = 0, streakCount: Int = 0) {
        self.nickname = nickname
        self.totalDistance = totalDistance
        self.logCount = logCount
        self.streakCount = streakCount
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubviews(nameLabel, despLabel, cardStackView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalToSuperview().offset(40)
        }
        
        despLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        cardStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(despLabel.snp.bottom).offset(24)
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
//            MypageProfileView(nickname: "행복한쿼카러너", totalDistance: 12.3, logCount: 50, streakCount: 10)
//        }
//        .previewLayout(.sizeThatFits) // 크기를 적절하게 조절하여 미리보기 가능
//        .padding()
//    }
//}
//
//// UIKit 뷰를 SwiftUI에서 렌더링하는 Helper
//struct UIViewPreview<T: UIView>: UIViewRepresentable {
//    let viewBuilder: () -> T
//    
//    init(_ viewBuilder: @escaping () -> T) {
//        self.viewBuilder = viewBuilder
//    }
//    
//    func makeUIView(context: Context) -> T {
//        return viewBuilder()
//    }
//    
//    func updateUIView(_ uiView: T, context: Context) {}
//}
//#endif
