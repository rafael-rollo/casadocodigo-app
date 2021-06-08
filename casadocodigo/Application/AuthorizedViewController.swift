//
//  AuthenticatedViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 03/06/21.
//

import UIKit

class AuthorizedViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()

        guard UserDefaults.standard.hasAuthenticatedUser() else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInViewController")
            present(controller, animated: true) {
                let pullDownDismissGesture = controller.presentationController?.presentedView?.gestureRecognizers?.first
                pullDownDismissGesture?.isEnabled = false
            }
            
            return
        }
        
        let user = UserDefaults.standard.getAuthenticated()!
        denyIfNeeded(user)
    }
    
    open func authorizedRoles() -> [Role] {
        fatalError("Please implement the \(#function) in your AuthorizedViewController")
    }
    
    fileprivate func denyIfNeeded(_ user: User) {
        let isAuthorizedUser = self.authorizedRoles().reduce(false) {
            $1 == user.role || $0
        }
        
        if !isAuthorizedUser {
            let goBack: (UIAlertAction) -> Void = { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            
            Alert.show(title: "Access Denied",
                       message: "You have no rights to see this screen",
                       onDismiss: goBack,
                       in: self)
        }
    }
}
