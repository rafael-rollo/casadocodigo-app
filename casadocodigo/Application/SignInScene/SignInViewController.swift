//
//  SignInViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLayout()
    }
    
    func adjustLayout() {
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor(named: "strongOrange")?.cgColor
        signInButton.layer.cornerRadius = 24        
    }
    
    @IBAction func signInUser(_ sender: UIButton) {
        Alert.init(controller: self).show(message: "Logado")
    }
}
