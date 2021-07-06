//
//  ViewCode.swift
//  casadocodigo
//
//  Created by rafael.rollo on 06/07/21.
//

import Foundation

protocol ViewCode {
    func setup()
    func addViews()
    func addConstraints()
    func addTheme()
}

extension ViewCode {
    func setup() {
        addViews()
        addConstraints()
        addTheme()
    }
    
    func addTheme() {}
}
