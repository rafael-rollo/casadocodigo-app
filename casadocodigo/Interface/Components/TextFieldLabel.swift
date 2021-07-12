//
//  TextFieldLabel.swift
//  casadocodigo
//
//  Created by rafael.rollo on 11/07/21.
//

import UIKit

class TextFieldLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: "HelveticaNeue", size: 16)
        textColor = .secondaryLabel
        text = "Title Label:"
    }
}
