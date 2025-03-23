//
//  TextFieldSystem.swift
//  RunLog
//
//  Created by 김도연 on 3/16/25.
//

import UIKit
import Combine
import SnapKit
import Then

open class RLTextField: UITextField {
    
    // MARK: - Properties
    public var padding: UIEdgeInsets
    private let underline = UIView()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    public init(
        padding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
        placeholder: String? = nil
    ) {
        self.padding = padding
        super.init(frame: .zero)
        
        setupUI()
        setupLayout()
        setupBinding()
        
        if let placeholder = placeholder {
            setPlaceholder(placeholder)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        borderStyle = .none
        backgroundColor = .clear
        attributedText = .RLAttributedString(text: "", font: .Headline1)
        isUserInteractionEnabled = true
        
        underline.backgroundColor = .Gray200
        addSubview(underline)
        setupBinding()
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        underline.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    // MARK: - Text Rect
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    // MARK: - Set Placeholder Color
    public func setPlaceholder(_ text: String, color: UIColor = .Gray300) {
        attributedPlaceholder = .RLAttributedString(text: text, font: .Headline2, color: color)
    }
    
    // MARK: - Bindings
    private func setupBinding() {
        self.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.attributedText = .RLAttributedString(text: text, font: .Headline1)
                self?.underline.backgroundColor = text.isEmpty ? .Gray200 : .LightGreen
            }
            .store(in: &cancellables)
    }
    
    public func setTextWithUnderline(_ value: String) {
        self.attributedText = .RLAttributedString(text: value, font: .Headline1)
        self.underline.backgroundColor = value.isEmpty ? .Gray200 : .LightGreen
    }
}
