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
        $0.attributedText = .RLAttributedString(text: "Hello World!", font: .Heading1, align: .center)
        $0.backgroundColor = .blue
    }
    
    var closeButton = UIButton().then {
        $0.setAttributedTitle(.RLAttributedString(text: "닫기", font: .Button, align: .center), for: .normal)
        $0.setImage(UIImage(systemName: RLIcon.fold.name), for: .normal)
        $0.backgroundColor = UIColor.orange
    }
    
    var lbl = UILabel().then {
        $0.font = .RLHeading1
    }
    
    lazy var rlBtn = RLButton(title: "예시 버튼", titleColor: .Gray000).then {
        $0.configureTitle(title: "타이틀 변경", titleColor: .Gray900, font: .RLButton)
        $0.configureRadius(8)
        $0.configureBackgroundColor(.LightGreen)
        $0.setHeight(100)
    }
    
    private let textField = RLTextField(placeholder: "닉네임을 입력하세요")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Gray900
        // Do any additional setup after loading the view.
        [label, closeButton, rlBtn, textField].forEach{ view.addSubview($0) }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        closeButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(label)
            $0.top.equalTo(label.snp.bottom)
        }
        rlBtn.snp.makeConstraints {
            // 버튼 width는 leading, trailing으로 잡아주면 좋아요
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        textField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24) // 좌우 여백 24
            $0.top.equalToSuperview().offset(100) // 상단 여백 50
            $0.height.equalTo(64)
        }
        
//        label.snp.makeConstraints {
//            $0.centerX.centerY.equalToSuperview()
//        }
//        closeButton.snp.makeConstraints {
//            $0.leading.trailing.equalTo(label)
//            $0.top.equalTo(label.snp.bottom)
//        }
//        rlBtn.snp.makeConstraints {
//            // 버튼 width는 leading, trailing으로 잡아주면 좋아요
//            $0.leading.trailing.equalToSuperview().inset(24)
//        }
    }
}


