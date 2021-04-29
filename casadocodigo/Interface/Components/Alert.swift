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
    
    func show(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default)
        alert.addAction(action)
        
        controller.present(alert, animated: true, completion: nil)
    }
}

extension Alert {
    static func show(title: String, message: String, in controller: UIViewController) {
        Alert(controller: controller).show(title: title, message: message)
    }
    
    static func show(message: String, in controller: UIViewController) {
        Alert(controller: controller).show(message: message)
    }
}
