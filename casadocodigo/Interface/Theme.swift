//
//  Theme.swift
//  casadocodigo
//
//  Created by rafael.rollo on 24/05/21.
//

import UIKit

struct Theme {}

extension Theme {
    struct spacing {
        static let zero: CGFloat = 0
        static let xxxsmall: CGFloat = 4
        static let xxsmall: CGFloat = 8
        static let xsmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 20
        static let large: CGFloat = 24
        static let xlarge: CGFloat = 32
        static let xxlarge: CGFloat = 40
        static let xxxlarge: CGFloat = 56
        static let huge: CGFloat = 72
        static let xhuge: CGFloat = 80
    }
}

extension UIColor {
    static var orangeColor = UIColor(red: 255/255, green: 170/255, blue: 86/255, alpha: 1)
}

extension UIView {
    convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.init(frame: frame)
    }
}
