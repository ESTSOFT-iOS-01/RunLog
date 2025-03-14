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
        $0.attributedText = .RLAttributedString(text: "\(nickname) 님", font: .Title)
    }
    
    lazy var despLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
        
        let totalDistanceString = totalDistance.toString()
        let fullText = "지금까지 총 \(totalDistanceString)km를 걸으셨어요!"
        
        $0.attributedText = fullText.styledText(
            highlightText: totalDistanceString,
            baseFont: .RLHeadline2,
            baseColor: .Gray000,
            highlightFont: .RLHeadline3,
            highlightColor: .LightPink
        )
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
        self.addSubviews(nameLabel, despLabel)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
