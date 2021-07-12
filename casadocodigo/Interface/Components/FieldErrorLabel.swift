//
//  FieldErrorLabel.swift
//  casadocodigo
//
//  Created by rafael.rollo on 11/07/21.
//

import UIKit

class FieldErrorLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: "HelveticaNeue", size: 14)
        textColor = UIColor(named: "danger")
        isHidden = true
    }
}
