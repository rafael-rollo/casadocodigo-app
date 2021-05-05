//
//  Decimal.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import Foundation

extension Decimal {
    
    func currencyValue() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        
        guard let formattedCurrency = formatter.string(from: self as NSNumber) else {
            return String(format: "$ %.02f", [self])
            
        }
        
        return formattedCurrency
    }
    
}
