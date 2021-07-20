//
//  ValidatedTextInput.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/07/21.
//

import UIKit

@IBDesignable class ValidatedTextInput: UIStackView  {
    private var defaultSpacing: CGFloat {
        return renderingOnPhone ? Theme.spacing.xxsmall : Theme.spacing.xsmall
    }
    
    private var fieldHeight: CGFloat {
        return renderingOnPhone ? 34 : 46
    }
    
    private var fieldFontSize: CGFloat {
        return renderingOnPhone ? 14 : 22
    }
    
    private lazy var titleLabel: TextFieldLabel = {
        return TextFieldLabel()
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue", size: fieldFontSize)
        textField.textColor = .secondaryLabel
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "Field placeholder"
        return textField
    }()

    private lazy var errorMessageLabel: FieldErrorLabel = {
        return FieldErrorLabel()
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
    
    func addConstraints() {
        textField.constrainHeight(to: fieldHeight)
    }
    
    func addTheme() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = defaultSpacing
    }
}
