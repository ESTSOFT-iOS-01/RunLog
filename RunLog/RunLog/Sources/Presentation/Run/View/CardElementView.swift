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
    // record로 안받고 value로 값만 받을려면 Any로 선언해서 configue에서 캐스팅 해줘도 될듯?
    enum ElementType: String {
        case time = "시간"
        case distance = "거리"
        case steps = "걸음수"
        
        var titleFont: RLFont {
            switch self {
            case .time: return .Heading1
            case .distance: return .Headline1
            case .steps: return .Headline1
            }
        }
        var valueFont: RLFont {
            switch self {
            case .time: return .Heading4
            case .distance: return .Title
            case .steps: return .Title
            }
        }
        var color: UIColor {
            switch self {
            case .time: return .LightOrange
            case .distance: return .LightPink
            case .steps: return .LightBlue
            }
        }
    }
    // MARK: - UI Components 선언
    var type: ElementType
    var title = UILabel()
    var value = UILabel()
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
        title.attributedText = .RLAttributedString(text: type.rawValue, font: type.titleFont)
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
    func setConfigure(text: String) {
        value.attributedText = .RLAttributedString(
            text: text,
            font: type.valueFont,
            color: type.color
        )
    }
}
