//
//  ActivityIndicatorView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 16/04/21.
//

import Foundation
import UIKit

fileprivate class CustomIndicator: UIActivityIndicatorView {
    var parent: UIView?

    override func stopAnimating() {
        if let parent = self.parent {
            parent.removeFromSuperview()
        }

        super.stopAnimating()
    }
}

extension UIActivityIndicatorView {
    
    static func customIndicator(to view: UIView) -> UIActivityIndicatorView {
        let loaderView = UIView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        let indicator = CustomIndicator(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loaderView)
        
        loaderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        loaderView.addSubview(indicator)
        
        indicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor).isActive = true
       
        indicator.parent = loaderView
        return indicator;
    }
    
}
