//
//  CalUnitView.swift
//  RunLog
//
//  Created by 김도연 on 3/17/25.
//

import UIKit
import SnapKit
import Then

final class CalUnitView: UIView {
    
    // MARK: - Properties
    private let placeHolderString = "최대 100km까지 입력 가능합니다"
    
    // MARK: - UI Components 선언
    private let exampleImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    private let despLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    lazy var unitField = RLTextField(placeholder: placeHolderString).then {
        $0.keyboardType = .decimalPad
    }
    
    private let exampleView = UIView().then {
        $0.backgroundColor = .Gray700
        $0.layer.cornerRadius = 12
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
        // UI 요소 추가
        backgroundColor = .Gray900
        
        exampleView.addSubviews(exampleImageView, despLabel)
        addSubviews(exampleView, unitField)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        exampleImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(32)
        }
        
        despLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
        }
        
        exampleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(exampleImageView.snp.width).multipliedBy(256.0 / 393.0)
        }
        
        unitField.snp.makeConstraints {
            $0.top.equalTo(exampleView.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func updateDescriptionText(with value: Double) {
        DispatchQueue.main.async { [self] in
            let unitString = (value * 0.3).formattedString
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
    
}
