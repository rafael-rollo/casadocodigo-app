//
//  CustomViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 17/06/21.
//

import UIKit

class CustomViewController: UIViewController {
    
    var defaultNavigationButtonItems: [NavigationBarItem] {
        if UserDefaults.standard.hasAuthenticatedUser() {
            return []
        }
    
        return [.button("login", self, #selector(presentLoginScene))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar(itemsOnTheRight: defaultNavigationButtonItems)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didUserSignedIn),
            name: .userSignedIn,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc open func presentLoginScene() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "SignInViewController")
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @objc open func didUserSignedIn() {
        setupNavigationBar(itemsOnTheRight: defaultNavigationButtonItems)
    }
}
