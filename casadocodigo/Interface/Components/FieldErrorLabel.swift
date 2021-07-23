//
//  FieldErrorLabel.swift
//  casadocodigo
//
//  Created by rafael.rollo on 11/07/21.
//

import UIKit

class FieldErrorLabel: UILabel {
    private var fontSize: CGFloat {
        return renderingOnPhone ? 14 : 22
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        font = UIFont(name: "HelveticaNeue", size: fontSize)
        textColor = UIColor(named: "danger")
        isHidden = true
    }
}
