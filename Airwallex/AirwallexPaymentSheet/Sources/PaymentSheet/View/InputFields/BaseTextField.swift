//
//  BaseTextField.swift
//  Airwallex
//
//  Created by Weiping Li on 2024/12/25.
//  Copyright © 2024 Airwallex. All rights reserved.
//

import UIKit
#if canImport(AirwallexCore)
import AirwallexCore
#endif

protocol EditingEventObserver {
    func handleEditingEvent(event: UITextField.Event, for textField: UITextField)
}

protocol BaseTextFieldConfiguring: AnyObject, ViewModelValidatable {
    /// If user editing is enabled, the text color will change based on this setting.
    var isEnabled: Bool { get }
    /// The text displayed in the embedded text field.
    var text: String? { get }
    /// If this value is not nil, it will be displayed instead of  `text`.
    var attributedText: NSAttributedString? { get }
    /// if the input text is valid
    var isValid: Bool { get }
    /// type of the text field
    var textFieldType: AWXTextFieldType { get }
    /// placeholder for text field
    var placeholder: String? { get }
    /// return key type of the text field
    var clearButtonMode: UITextField.ViewMode { get set }
    /// return key type of the text field
    var returnKeyType: UIReturnKeyType { get set }
    /// delegate for the embeded text field
    var textFieldDelegate: UITextFieldDelegate? { get }
}

class BaseTextField<T: BaseTextFieldConfiguring>: UIView, ViewConfigurable, UITextFieldDelegate {
    
    let textField: ContentInsetableTextField = {
        let view = ContentInsetableTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .awxColor(.textPrimary)
        view.font = .awxFont(.body2)
        view.setContentHuggingPriority(.defaultLow - 50, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh - 50, for: .horizontal)
        view.textInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        return view
    }()
    
    let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()
    
    let box: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.cornerRadius = .radius_l
        view.layer.borderColor = .awxCGColor(.borderDecorative)
        view.backgroundColor = .awxColor(.backgroundField)
        return view
    }()

    let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        textField.tintColor = .awxColor(.textLink)
        textField.setContentHuggingPriority(.defaultLow - 15, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultHigh - 15, for: .horizontal)
        addSubview(verticalStack)
        verticalStack.addArrangedSubview(box)
        box.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(textField)
        
        let constraints = [
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            horizontalStack.topAnchor.constraint(equalTo: box.topAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: box.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: box.trailingAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: box.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        updateBorderAppearance()

        textField.addTarget(self, action: #selector(editingDidBegin(_:)), for: UITextField.Event.editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd(_:)), for: UITextField.Event.editingDidEnd)
    }
    
    override var canBecomeFirstResponder: Bool {
        textField.canBecomeFirstResponder
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
    
    override var canResignFirstResponder: Bool {
        textField.canResignFirstResponder
    }
    
    override var isFirstResponder: Bool {
        textField.isFirstResponder
    }
    
    var isEnabled: Bool {
        get {
            textField.isEnabled
        }
        set {
            textField.isEnabled = newValue
            textField.textColor = newValue ? .awxColor(.textPrimary) : .awxColor(.textPlaceholder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var viewModel: T?
    
    func setup(_ viewModel: T) {
        self.viewModel = viewModel
        textField.update(for: viewModel.textFieldType)
        if let attributedText = viewModel.attributedText {
            textField.attributedText = attributedText
        } else if let text = viewModel.text {
            textField.text = text
        } else {
            textField.text = nil
        }
        
        if let placeholder = viewModel.placeholder, !placeholder.isEmpty {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [
                    .foregroundColor: UIColor.awxColor(.textPlaceholder),
                    .font: UIFont.awxFont(.body2)
                ]
            )
        } else {
            textField.attributedPlaceholder = nil
        }
        isEnabled = viewModel.isEnabled
        textField.clearButtonMode = viewModel.clearButtonMode
        textField.returnKeyType = viewModel.returnKeyType
        textField.delegate = viewModel.textFieldDelegate
        
        updateBorderAppearance()
    }
    
    func updateBorderAppearance() {
        guard let viewModel else { return }
        if textField.isFirstResponder {
            box.layer.borderColor = .awxCGColor(.borderInteractive)
            box.layer.borderWidth = 2
        } else {
            box.layer.borderColor = viewModel.isValid ? .awxCGColor(.borderDecorative) : .awxCGColor(.borderError)
            box.layer.borderWidth = 1
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateBorderAppearance()
        }
    }
    
    //  MARK: - UITextField.Event
    @objc func editingDidBegin(_ textField: UITextField) {
        updateBorderAppearance()
    }
    
    @objc func editingDidEnd(_ textField: UITextField) {
        updateBorderAppearance()
    }
}
