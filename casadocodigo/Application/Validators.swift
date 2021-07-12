//
//  Validator.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/07/21.
//

import UIKit

class Validator {
    
    private var targetInputViews: [ValidatedInputView] = []
    private var validationErrorCount: Int = 0
    
    private func reset() {
        validationErrorCount = 0
    }
    
    private func validate(text: String, with ruls: [Rule]) -> String? {
        return ruls.compactMap({ $0.check(text) }).first
    }
    
    private func validate(_ input: ValidatedInputView) {
        guard let message = validate(text: input.getText() ?? "", with: input.rules) else {
            input.setErrorMessageHidden()
            return
        }

        validationErrorCount += 1
        input.showError(message)
    }
    
    func requireValidation(on inputView: ValidatedInputView) {
        targetInputViews.append(inputView)
    }
    
    func isFormValid() -> Bool {
        reset()
        
        targetInputViews.forEach { inputView in
            validate(inputView)
        }
        
        return validationErrorCount == 0
    }
}

enum Rule {
    case notEmpty
    case validEmail
    case validIsbnFormat
    case min(Int)
    case minLength(Int)
    case minDecimal(Double)
    case validURL
    case validFullName
    
    func check(_ text: String) -> String? {
        switch self {
        case .notEmpty:
            return text.isEmpty ? "Não pode estar vazio" : nil
            
            
        case .validEmail:
            let regex = #"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}"#

            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: text) ? nil : "Informe um e-mail válido"
            
            
        case .validIsbnFormat:
            let regex = #"^(?=(?:\D*\d){10}(?:(?:\D*\d){3})?$)[\d-]+$"#

            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: text) ? nil : "Informe um ISBN correto"
        
            
        case let .min(minValue):
            guard let number = Int(text) else {
                return "Informe um número válido"
            }
            
            return number >= minValue ? nil : "Não deve ser menor que \(minValue)"
            
            
        case let .minLength(minLengthValue):
            return text.count >= minLengthValue ? nil : "Deve conter mais de \(minLengthValue) caracteres"
            
            
        case let .minDecimal(minDecimalValue):
            guard let decimal = Double(text) else {
                return "Informe um valor válido"
            }
            
            return decimal >= minDecimalValue ? nil : "Não deve ser menor que \(minDecimalValue)"
        
            
        case .validURL:
            let message = "Informe uma URI válida"
            
            guard let url = NSURL(string: text) else {
                return message
            }

            return UIApplication.shared.canOpenURL(url as URL) ? nil : message
        
        
        case .validFullName:
            return text.components(separatedBy: " ").count >= 2 ? nil : "Informe um sobrenome"
        }
    }
}
