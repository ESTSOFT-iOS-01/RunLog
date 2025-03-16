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
    
    public lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.sectionHeaderTopPadding = 4
        $0.rowHeight = 48
        $0.contentInsetAdjustmentBehavior = .never
        $0.isScrollEnabled = false
        $0.bounces = false
        $0.register(SettingMenuCell.self, forCellReuseIdentifier: SettingMenuCell.identifier)
    }
    
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
        self.addSubviews(nameLabel, despLabel, cardStackView, tableView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(146)
        }
        
        despLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        cardStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(despLabel.snp.bottom).offset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
