//
//  WithAvoidingKeyboard.swift
//  casadocodigo
//
//  Created by rafael.rollo on 24/06/21.
//

import UIKit

protocol KeyboardAvoidableViewDelegate: UIViewController, UITextFieldDelegate {
    var activeField: UITextField? { get set }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidEndEditing(_ textField: UITextField)
}
 
class KeyboardAvoidableView: UIScrollView {
    weak var keyboardAvoidableViewDelegate: KeyboardAvoidableViewDelegate?
    
    // for using the custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // for using the custom view in interface builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let parentViewController = keyboardAvoidableViewDelegate else { return }
        
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                                as! NSValue).cgRectValue.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
        
        var referenceRect = parentViewController.view.frame
        referenceRect.size.height -= keyboardHeight
        
        guard let activeField = parentViewController.activeField else { return }
        
        if !referenceRect.contains(activeField.frame.origin) {
            scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
    }
}
