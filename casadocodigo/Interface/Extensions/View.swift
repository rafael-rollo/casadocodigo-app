//
//  View.swift
//  casadocodigo
//
//  Created by rafael.rollo on 26/04/21.
//

import Foundation
import UIKit

extension UIView {
    func roundTheShape() {
        guard bounds.width == bounds.height else {
            debugPrint("The dimensions of the image must comprise a square to use the rounded shape")
            return
        }
        
        layer.cornerRadius = self.bounds.width / 2
    }
}
