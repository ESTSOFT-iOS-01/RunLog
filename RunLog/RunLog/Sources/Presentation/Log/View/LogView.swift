//
//  LogView.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import SnapKit
import Then

final class LogView: UIView {
    
    // MARK: - UI Components
    lazy var segmentedControl = UnderlineSegmentedControl(
        items: ["캘린더", "타임라인"]
    ).then {
        $0.selectedSegmentIndex = 0
    }
    
    lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

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
        addSubviews(segmentedControl, pageViewController.view)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        segmentedControl.snp.makeConstraints {
            $0.height.equalTo(31)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(8)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.trailing.leading.bottom.equalToSuperview()
            $0.top.equalTo(segmentedControl.snp.bottom)
        }
    }
}
