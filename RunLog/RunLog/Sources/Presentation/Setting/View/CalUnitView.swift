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
    
    // MARK: - UI Components 선언
    private let placeHolderString = "최대 100km까지 입력 가능합니다"
    private lazy var exampleImageView = UIImageView().then {
        $0.backgroundColor = .Gray700
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    lazy var unitField = RLTextField(placeholder: placeHolderString)
    
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
        // UI 요소 추가
        backgroundColor = .Gray900
        addSubviews(exampleImageView, unitField)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        exampleImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(exampleImageView.snp.width).multipliedBy(256.0 / 393.0)
        }
        
        unitField.snp.makeConstraints {
            $0.top.equalTo(exampleImageView.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    func configure(originText : String) {
        unitField.text = originText
    }
}
