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
    
    @IBOutlet weak var centerYAlignmentContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var userAuthentication: UserAuthentication
    
    init(userAuthentication: UserAuthentication = UserAuthentication(),
         nibName: String?,
         bundle: Bundle?) {
        self.userAuthentication = userAuthentication
        super.init(nibName: nibName, bundle: bundle)
    }
        
    required init?(coder: NSCoder) {
        self.userAuthentication = UserAuthentication()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustLayout()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toogleFormConstraintsPriority(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(toogleFormConstraintsPriority(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func adjustLayout() {
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor(named: "strongOrange")?.cgColor
        signInButton.layer.cornerRadius = 24
    }
    
    @objc func toogleFormConstraintsPriority(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                                as! NSValue).cgRectValue.height
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            let bottomPadding: CGFloat = 32
            bottomConstraint.constant = keyboardHeight + bottomPadding
            bottomConstraint.priority = UILayoutPriority.required

            centerYAlignmentContraint.priority = UILayoutPriority.defaultLow
        } else {
            centerYAlignmentContraint.priority = UILayoutPriority.required

            bottomConstraint.constant = 0
            bottomConstraint.priority = UILayoutPriority.defaultLow
        }
    }
    
    func getSigninInfoFromForm() -> (String, String)? {
        guard let email = emailTextField.text, !email.isEmpty else {
            Alert.show(title: "Ops", message: "Informe seu email", in: self)
            return nil
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            Alert.show(title: "Ops", message: "Informe sua senha de acesso", in: self)
            return nil
        }
                
        return (email, password)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func signInUser(_ sender: UIButton) {
        guard let (email, password) = getSigninInfoFromForm() else { return }
        
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        userAuthentication.authenticateUser(identifiedBy: email,
                                            withPassword: password) { [weak self] user in
            indicator.stopAnimating()
            
            user.email = email
            UserDefaults.standard.setAuthenticated(user)
            
            self?.dismiss(animated: true, completion: nil)
            
        } failureHandler: { message in
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: message, in: self)
        }
    }
}

// MARK: - Text Fields delegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
