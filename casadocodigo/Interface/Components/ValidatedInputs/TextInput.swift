//
//  ValidatedTextInput.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/07/21.
//

import UIKit

@IBDesignable class ValidatedTextInput: UIStackView  {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.textColor = .secondaryLabel
        label.text = "Title Label:"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue", size: 14)
        textField.textColor = .secondaryLabel
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "Field placeholder"
        return textField
    }()

    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = UIColor(named: "danger")
        label.isHidden = true
        return label
    }()
    
    var rules: [Rule] = []
    
    var editingDidEnd: ((_ text: String) -> Void)?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func config(title: String,
             placeholder: String,
             keyboardType: UIKeyboardType = .default,
             rules: [Rule]) {
        textField.delegate = self
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        
        titleLabel.text = title
        self.rules = rules
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
}

extension ValidatedTextInput: ValidatedInputView {
    func getText() -> String? {
        return textField.text
    }
    
    func setErrorMessageHidden() {
        errorMessageLabel.text = ""
        errorMessageLabel.isHidden = true
    }
    
    func showError(_ message: String) {
        errorMessageLabel.text = message
        errorMessageLabel.isHidden = false
    }
}

extension ValidatedTextInput: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let editingDidEnd = editingDidEnd {
            editingDidEnd(textField.text ?? "")
        }
    }
}

extension ValidatedTextInput: ViewCode {
    func addViews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(textField)
        addArrangedSubview(errorMessageLabel)
    }
    
    func addTheme() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = Theme.spacing.xxsmall
    }
}
