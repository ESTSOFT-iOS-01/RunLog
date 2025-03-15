//
//  UnderlineSegmentedControl.swift
//  RunLog
//
//  Created by 신승재 on 3/15/25.
//

import UIKit
import SnapKit

final class UnderlineSegmentedControl: UISegmentedControl {
    
    // MARK: - UI Components
    private lazy var baseLineView = UIView().then {
        $0.backgroundColor = .Gray500
        self.addSubview($0)
    }

    private lazy var underlineView = UIView().then {
        $0.backgroundColor = .LightGreen
        self.addSubview($0)
    }
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        self.setupUI()
        self.removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let segmentWidth = self.bounds.width / CGFloat(self.numberOfSegments)
        let height: CGFloat = 2.0
        let yPosition = self.bounds.height - height
        
        baseLineView.frame = CGRect(
            x: 0,
            y: yPosition,
            width: self.bounds.width,
            height: height
        )

        let underlineFinalXPosition = CGFloat(self.selectedSegmentIndex) * segmentWidth
          UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
              self.underlineView.frame = CGRect(
                x: underlineFinalXPosition,
                y: yPosition,
                width: segmentWidth,
                height: height
              )
          })
    }
    
    private func setupUI() {
        
        let unselectedColor: UIColor = .Gray500
        let selectedColor: UIColor = .LightGreen
        
        self.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: unselectedColor,
                .font: UIFont.RLSegment2
            ],
            for: .normal
        )
        self.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: selectedColor,
                .font: UIFont.RLSegment1
            ],
            for: .selected
        )
        self.setContentPositionAdjustment(
            UIOffset(horizontal: 0, vertical: -5),
            forSegmentType: .any,
            barMetrics: .default
        )
        self.clipsToBounds = false
    }
}

extension UnderlineSegmentedControl {
    // MARK: - Private Functions
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        self.setDividerImage(
            image,
            forLeftSegmentState: .selected,
            rightSegmentState: .normal,
            barMetrics: .default
        )
    }
}
