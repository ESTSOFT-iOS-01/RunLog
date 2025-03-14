//
//  ViewController.swift
//  RunLog
//
//  Created by 김도연 on 3/13/25.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {
    var label = UILabel().then {
        $0.attributedText = DesignSystemFont.Title.attributedString(
            for: "Hello World!",
            color: DesignSystemColor.Gray00.value
        )
        $0.backgroundColor = .blue
    }
    var closeButton = UIButton().then {
        $0.setAttributedTitle(DesignSystemFont.Heading1.attributedString(
            for: "닫기",
            color: DesignSystemColor.Gray00.value
        ), for: .normal)
        $0.setImage(UIImage(systemName: DesignSystemIcon.closeButton.name), for: .normal)
        $0.backgroundColor = UIColor.orange
    }
    
    var lbl = UILabel().then {
        $0.font = .LRHeading1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        [label, closeButton].forEach{ view.addSubview($0) }
        
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        closeButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(label)
            $0.top.equalTo(label.snp.bottom)
        }
    }
}


