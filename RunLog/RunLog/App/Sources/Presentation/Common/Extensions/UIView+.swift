//
//  UIView+.swift
//  RunLog
//
//  Created by 김도연 on 3/14/25.
//

import UIKit

extension UIView {
    /// 여러 개의 서브뷰를 한 번에 추가하는 함수
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
