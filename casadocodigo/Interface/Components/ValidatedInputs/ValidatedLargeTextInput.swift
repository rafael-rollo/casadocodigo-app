//
//  LargeTextInput.swift
//  casadocodigo
//
//  Created by rafael.rollo on 10/07/21.
//

import UIKit

@IBDesignable class ValidatedLargeTextInput: UIStackView  {
    private lazy var titleLabel: TextFieldLabel = {
        return TextFieldLabel()
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "HelveticaNeue", size: 14)
        textView.textColor = .secondaryLabel
        textView.backgroundColor = .white
        textView.configureBorders()
        return textView
    }()

    private lazy var errorMessageLabel: FieldErrorLabel = {
        return FieldErrorLabel()
    }()
    
    var placeholder: String = "Text view placeholder" {
        didSet {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    var rules: [Rule] = []
        
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
        textView.delegate = self
        textView.keyboardType = keyboardType
        
        titleLabel.text = title
        
        self.placeholder = placeholder
        self.rules = rules
    }
    
    func setText(_ text: String) {
        textView.text = text
        textView.textColor = .secondaryLabel
    }
}

extension ValidatedLargeTextInput: ValidatedInputView {
    func getText() -> String? {
        return textView.text
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

extension ValidatedLargeTextInput: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.secondaryLabel
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ValidatedLargeTextInput: ViewCode {
    func addViews() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(textView)
        addArrangedSubview(errorMessageLabel)
    }
    
    func addConstraints() {
        textView.constrainHeight(to: 120)
    }
    
    func addTheme() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = Theme.spacing.xxsmall
    }
}
