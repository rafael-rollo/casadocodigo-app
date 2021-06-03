//
//  AuthenticatedViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 03/06/21.
//

import UIKit

class AuthorizedViewController: UIViewController {

    var authenticationRepository: UserAuthenticationRepository
    
    init(authenticationRepository: UserAuthenticationRepository = UserAuthenticationRepository(),
         nibName: String? = nil,
         bundle: Bundle? = nil) {
        self.authenticationRepository = authenticationRepository
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        self.authenticationRepository = UserAuthenticationRepository()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = authenticationRepository.get() else {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignInViewController")
            controller.modalPresentationStyle = .fullScreen
            
            present(controller, animated: true, completion: nil)
            return
        }
    }
}
