//
//  ActivityIndicatorView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 16/04/21.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    
    static func customIndicator(to view: UIView) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        return indicator;
    }
    
}
