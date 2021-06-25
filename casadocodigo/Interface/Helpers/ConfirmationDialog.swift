//
//  ConfirmationDialog.swift
//  casadocodigo
//
//  Created by rafael.rollo on 28/04/21.
//

import UIKit

class ConfirmationDialog: NSObject {
    
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func execute(title: String? = nil, message: String, confirmationHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmationAction = UIAlertAction(title: "Ok", style: .default, handler: confirmationHandler)
        alert.addAction(confirmationAction)
        
        let cancellationAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancellationAction)
        
        controller.present(alert, animated: true, completion: nil)
    }
}

extension ConfirmationDialog {
    static func execute(in controller: UIViewController, title: String? = nil,
                        message: String, confirmationHandler: @escaping (UIAlertAction) -> Void) {
        ConfirmationDialog(controller: controller).execute(title: title, message: message, confirmationHandler: confirmationHandler)
    }
}
