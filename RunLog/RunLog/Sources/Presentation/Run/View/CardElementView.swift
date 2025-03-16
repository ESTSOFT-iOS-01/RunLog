//
//  CardElementView.swift
//  RunLog
//
//  Created by 심근웅 on 3/15/25.
//

import UIKit
import SnapKit
import Then

final class CardElementView: UIView {
    var record: SectionRecord? {
        didSet {
            configure()
        }
    }
    enum ElementType {
        case time
        case distance
        case steps
    }
    // MARK: - UI Components 선언
    var type: ElementType
    var title = UILabel().then {
        $0.text = "title"
    }
    var value = UILabel().then {
        $0.text = "value"
    }
    // MARK: - Init
    init(type: ElementType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        self.addSubviews(title, value)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        title.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        value.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(title.snp.bottom)
        }
    }
    
    // MARK: - Configure
    private func configure() {
        guard let record = self.record else { return }
        // 뷰 설정
        switch type {
        case .time:
            title.attributedText = .RLAttributedString(text: "시간", font: .Heading1, color: .Gray000)
            value.attributedText = .RLAttributedString(text: "\(record.sectionTime.asTimeString)", font: .Heading4, color: .LightOrange)
        case .distance:
            title.attributedText = .RLAttributedString(text: "거리", font: .Headline1, color: .Gray000)
            value.attributedText = .RLAttributedString(text: "\(record.distance.toString())km", font: .Title, color: .LightPink)
        case .steps:
            title.attributedText = .RLAttributedString(text: "걸음수", font: .Headline1, color: .Gray000)
            value.attributedText = .RLAttributedString(text: "\(record.steps.formattedWithComma())", font: .Title, color: .LightBlue)
        }
    }
}
