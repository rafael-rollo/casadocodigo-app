//
//  IdiomHelper+UITraitEnvironment.swift
//  casadocodigo
//
//  Created by rafael.rollo on 13/07/21.
//

import UIKit

extension UITraitEnvironment {
    var renderingOnPhone: Bool {
        return traitCollection.userInterfaceIdiom == .phone
    }
}
