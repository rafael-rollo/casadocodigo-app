//
//  View.swift
//  casadocodigo
//
//  Created by rafael.rollo on 26/04/21.
//

import Foundation
import UIKit

extension UIView {
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    fileprivate func round(for width: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = width / 2
    }
    
    fileprivate func fallback() {
        guard bounds.width == bounds.height else {
            debugPrint("The dimensions of the image must comprise a square to use the rounded shape")
            return
        }
        
        round(for: bounds.width)
    }
    
    func roundTheShape() {
        guard let width = widthConstraint?.constant else {
            return fallback()
        }
        
        round(for: width)
    }
}
