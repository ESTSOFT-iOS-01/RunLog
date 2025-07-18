//
//  CalUnitView.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import SnapKit
import Then

/// 기록 시각화 단위 설정 화면의 UI 구성 뷰
final class CalUnitView: UIView {
    
    // MARK: - Properties
    private let placeHolderString = "최대 100km까지 입력 가능합니다"
    private let movementScaleFactor: Double = 0.3 // 시각화 배율
    
    // MARK: - UI Components 선언
    /// 예시 이미지
    private let exampleImageView = UIImageView().then {
        $0.image = UIImage(named: "UnitExample")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    /// 설명 라벨 (유닛에 따른 표시 설명)
    private let despLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    /// 단위 입력 필드
    lazy var unitField = RLTextField(placeholder: placeHolderString).then {
        $0.keyboardType = .decimalPad
    }
    
    /// 예시 박스 뷰
    private let exampleView = UIView().then {
        $0.backgroundColor = .Gray700
        $0.layer.cornerRadius = DynamicSize.scaledSize(12)
        $0.clipsToBounds = true
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
        
        exampleView.addSubviews(exampleImageView, despLabel)
        addSubviews(exampleView, unitField)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        exampleImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.top.equalToSuperview().inset(DynamicSize.scaledSize(32))
        }
        
        despLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(DynamicSize.scaledSize(24))
            $0.bottom.equalToSuperview().inset(DynamicSize.scaledSize(32))
        }
        
        exampleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicSize.scaledSize(24))
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(exampleImageView.snp.width).multipliedBy(256.0 / 393.0)
        }
        
        unitField.snp.makeConstraints {
            $0.top.equalTo(exampleView.snp.bottom).offset(DynamicSize.scaledSize(48))
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Update
    /// 입력값에 따라 설명 라벨을 업데이트합니다.
    /// - Parameter value: 입력된 거리 단위 문자열
    func updateDescriptionText(with value: String) {
        let visibleUnit = (Double(value) ?? 10.0) * movementScaleFactor
        let formattedUnit = Double(visibleUnit.toString(withDecimal: 3)) ?? 3.3
        let unitString = formattedUnit.formattedString

        let fullText = "하루에 \(unitString)km 이동하면 이렇게 표시돼요"

        despLabel.attributedText = fullText.styledText(
            highlightText: unitString,
            baseFont: .RLBody1,
            baseColor: .Gray000,
            highlightFont: .RLBody1,
            highlightColor: .LightGreen
        )
    }
}
