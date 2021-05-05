//
//  TextView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import Foundation
import UIKit

extension UITextView {
    func configureBorders() {
        layer.cornerRadius = 6
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
