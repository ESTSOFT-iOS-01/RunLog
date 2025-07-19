//
//  UIButton+.swift
//  RunLog
//
//  Created by 신승재 on 3/17/25.
//

import UIKit
import Combine

extension UIButton {
    public var publisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}
