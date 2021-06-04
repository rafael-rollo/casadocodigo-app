//
//  AuthenticatedViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 03/06/21.
//

import UIKit

class AuthorizedViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()

        guard UserDefaults.standard.hasAuthenticatedUser() else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInViewController")
            controller.modalPresentationStyle = .fullScreen
            
            present(controller, animated: true, completion: nil)
            return
        }
    }
    
    func authorizedRoles() -> [Role] {
        fatalError("Please implement the \(#function) in your AuthorizedViewController")
    }
}
