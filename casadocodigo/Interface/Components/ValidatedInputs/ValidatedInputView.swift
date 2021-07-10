//
//  ValidatedInputView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 10/07/21.
//

import UIKit

protocol ValidatedInputView: UIView {
    var rules: [Rule] { get set }
    
    func getText() -> String?
    func setErrorMessageHidden()
    func showError(_ message: String)
}
