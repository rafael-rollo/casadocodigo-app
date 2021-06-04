//
//  Alert.swift
//  casadocodigo
//
//  Created by rafael.rollo on 16/04/21.
//

import UIKit

class Alert: NSObject {

    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func show(title: String? = nil, message: String, onDismiss: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: onDismiss)
        alert.addAction(action)
        
        controller.present(alert, animated: true, completion: nil)
    }
}

extension Alert {
    static func show(title: String? = nil,
                     message: String,
                     onDismiss: ((UIAlertAction) -> Void)? = nil,
                     in controller: UIViewController) {
        Alert(controller: controller).show(title: title, message: message, onDismiss: onDismiss)
    }
}
