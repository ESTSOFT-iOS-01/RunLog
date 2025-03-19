//
//  CalendarView.swift
//  RunLog
//
//  Created by 신승재 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class CalendarView: UIView {
    
    // MARK: - UI Components 선언
    private let walkImage = UIImageView().then {
        $0.image = UIImage(named: RLIcon.walk.name)
    }
    
    private var nicknameLabel = UILabel().then {
        var nickname = "행복한쿼카러너화이팅"
        $0.attributedText = .RLAttributedString(
            text: nickname + " 님,",
            font: .Heading1,
            color: .Gray000
        )
    }
    
    private let bottomLabel = UILabel().then {
        let text = "오늘도 가볍게 동네 산책 어때요?"
        $0.attributedText = .RLAttributedString(
            text: text,
            font: .Body1,
            color: .Gray000
        )
    }
    
    private let topBanner = UIView().then {
        $0.backgroundColor = .Gray700
        $0.layer.cornerRadius = 12
    }
    
    let leftArrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: RLIcon.leftArrow.name), for: .normal)
        $0.setPreferredSymbolConfiguration(
            .init(pointSize: 15, weight: .semibold), forImageIn: .normal
        )
        $0.backgroundColor = .clear
        $0.tintColor = .Gray000
    }
    
    let rightArrowButton = UIButton().then {
        $0.setImage(UIImage(systemName: RLIcon.rightArrow.name), for: .normal)
        $0.setPreferredSymbolConfiguration(
            .init(pointSize: 15, weight: .semibold), forImageIn: .normal
        )
        $0.backgroundColor = .clear
        $0.tintColor = .Gray000
    }
    
    var calendarTitleLabel = UILabel().then {
        $0.attributedText = .RLAttributedString(
            text: "25년 3월",
            font: .Heading2,
            color: .Gray000
        )
    }
    
    private lazy var calendarTitleContainer = UIStackView(
        arrangedSubviews: [leftArrowButton, calendarTitleLabel ,rightArrowButton]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 9
        $0.alignment = .center
    }
    
    private lazy var weekdayLabels: [UILabel] = {
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        return weekdays.map { weekday in
            let label = UILabel().then {
                $0.text = weekday
                $0.attributedText = .RLAttributedString(
                    text: weekday,
                    font: .Label2,
                    color: .Gray300
                )
                $0.textAlignment = .center
            }
            return label
        }
    }()
    
    private lazy var weekdaysContainer = UIStackView(
        arrangedSubviews: weekdayLabels
    ).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().then {
            let itemWidth = (UIScreen.main.bounds.width - 48) / 7
            $0.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
            $0.minimumLineSpacing = 0
            $0.minimumInteritemSpacing = 0
        }
    ).then {
        $0.backgroundColor = .clear
        $0.register(
            CalendarViewCell.self,
            forCellWithReuseIdentifier: CalendarViewCell.identifier
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
        backgroundColor = .Gray900
        topBanner.addSubviews(walkImage, nicknameLabel, bottomLabel)
        addSubviews(
            topBanner, calendarTitleContainer, weekdaysContainer, collectionView
        )
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        walkImage.snp.makeConstraints {
            $0.height.width.equalTo(64)
            $0.top.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(26)
            $0.leading.equalTo(walkImage.snp.trailing).offset(24)
            $0.top.equalToSuperview().offset(18)
        }
        
        bottomLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.leading.equalTo(walkImage.snp.trailing).offset(24)
            $0.bottom.equalToSuperview().offset(-21)
        }
        
        topBanner.snp.makeConstraints {
            $0.height.equalTo(90)
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        leftArrowButton.snp.makeConstraints {
            $0.width.equalTo(26)
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.width.equalTo(26)
        }
        
        calendarTitleContainer.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.top.equalTo(topBanner.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
        }
        
        weekdaysContainer.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalTo(calendarTitleContainer.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(weekdaysContainer.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    private func configure() {
        // 뷰 설정
    }
}
