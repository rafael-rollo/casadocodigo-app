//
//  Date.swift
//  casadocodigo
//
//  Created by rafael.rollo on 10/05/21.
//

import Foundation

extension Date {
    static func fromString(_ dateAsString: String, formattedBy formatPattern: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = formatPattern

        return formatter.date(from: dateAsString)
    }
}
