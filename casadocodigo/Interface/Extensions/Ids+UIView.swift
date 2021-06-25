//
//  IdentifiableView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 29/04/21.
//

import Foundation
import UIKit

/**
    Identifying Views that is retrieved by ReuseIdentifier to favor reusing
 */
protocol ReusableView: UIView {
    static var reuseId: String { get }
}

extension ReusableView {
    static var reuseId: String {
        return String(describing: self)
    }
}

/**
    Identifying Views that have a nib file that describes them
 */
protocol IdentifiableView: UIView {
    static var nibName: String { get }
}

extension IdentifiableView {
    static var nibName: String {
        return String(describing: self)
    }
}
