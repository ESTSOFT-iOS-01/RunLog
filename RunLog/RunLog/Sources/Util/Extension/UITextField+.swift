//
//  UITextField.swift
//  RunLog
//
//  Created by 신승재 on 3/17/25.
//

import UIKit
import Combine

extension UITextField {
    var publisher: AnyPublisher<String, Never> {
        controlPublisher(for: .editingChanged)
            .compactMap { $0 as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
