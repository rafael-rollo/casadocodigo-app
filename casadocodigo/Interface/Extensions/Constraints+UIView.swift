//
//  View.swift
//  casadocodigo
//
//  Created by rafael.rollo on 26/04/21.
//

import Foundation
import UIKit

extension UIView {
    func constrainTo(boundsOf view: UIView) {
        let constraints = [
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func constrainTo(safeBoundsOf view: UIView) {
        let constraints = [
            self.topAnchor.constraint(equalTo: view.safeTopAnchor),
            self.leadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.safeTrailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.safeBottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func constrainHeight(to constant: CGFloat) {
        let heightConstraint = [
            self.heightAnchor.constraint(equalToConstant: constant)
        ]
        
        NSLayoutConstraint.activate(heightConstraint)
    }
}
