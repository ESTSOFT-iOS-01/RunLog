//
//  MypageProfileView.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit
import SnapKit
import Then

/// 마이페이지 메인 프로필 영역을 구성하는 뷰
final class MypageProfileView: UIView {
    
    // MARK: - UI Components 선언
    /// 사용자 닉네임 라벨
    private let nameLabel = UILabel().then {
        $0.numberOfLines = 1
    }

    /// 총 거리 설명 라벨
    private let despLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }

    /// 운동 기록 카드
    private let logCard = ProfileCardView()

    /// 스트릭 카드
    private let streakCard = ProfileCardView()

    /// 카드 2개를 나란히 담는 StackView
    private lazy var cardStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logCard, streakCard])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    /// 설정 메뉴를 표시할 테이블뷰
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
    init() {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .Gray900
        addSubviews(nameLabel, despLabel, cardStackView, tableView)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(40))
        }
        
        despLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(DynamicSize.scaledSize(4))
        }
        
        cardStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(despLabel.snp.bottom).offset(DynamicSize.scaledSize(24))
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(DynamicSize.scaledSize(40))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    /// 유저 정보를 기반으로 프로필 UI를 구성합니다.
    /// - Parameter config: 유저 정보 모델
    func configure(with config: UserInfoVO) {
        nameLabel.attributedText = .RLAttributedString(
            text: config.displayNickname,
            font: .Title,
            color: .Gray000
        )

        despLabel.attributedText = config.summaryMessage.styledText(
            highlightText: config.formattedTotalDistance,
            baseFont: .RLHeadline2,
            baseColor: .Gray000,
            highlightFont: .RLHeadline3,
            highlightColor: .LightPink
        )

        logCard.configure(property: .logCount, value: config.logCount)
        streakCard.configure(property: .streak, value: config.streakCount)
    }
}
