//
//  NewAuthorViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 23/04/21.
//

import UIKit
import AlamofireImage

protocol NewAuthorViewControllerDelegate: class {
    func didAuthorCreated(_ author: AuthorResponse)
}

class NewAuthorViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: NewAuthorViewControllerDelegate?

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var pictureUrlTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var technologiesTextField: UITextField!
    @IBOutlet weak var addAuthorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.configure(navigationController, current: self)
    
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        adjustLayout()
    }
    
    private func adjustLayout() {
        self.sectionTitle.label.text = "Novo autor"
        
        self.profilePictureView.roundTheShape()
        
        self.bioTextView.layer.cornerRadius = 6
        self.bioTextView.layer.borderWidth = 0.2
        self.bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.addAuthorButton.layer.cornerRadius = 10
        self.addAuthorButton.showsTouchWhenHighlighted = true
        self.addAuthorButton.addTarget(self, action: #selector(authorAddingButtonPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func pictureFieldEditingDidEnd(_ sender: UITextField) {
        guard let pictureURLAsString = self.pictureUrlTextField.text,
              !pictureURLAsString.isEmpty else { return }
        
        guard let pictureURL = URL(string: pictureURLAsString) else { return }
        
        self.profilePictureView.af.setImage(withURL: pictureURL)
    }
    
    private func getAuthorFromForm() -> AuthorRequest? {
        guard let pictureURL = self.pictureUrlTextField.text, !pictureURL.isEmpty else {
            Alert.show(title: "Ops", message: "Adicione uma URL válida para a foto de perfil do autor", in: self)
            return nil
        }
        
        guard let fullName = self.nameTextField.text, !fullName.isEmpty else {
            Alert.show(title: "Ops", message: "O campo nome é obrigatório", in: self)
            return nil
        }
        
        guard fullName.components(separatedBy: " ").count >= 2 else {
            Alert.show(title: "Ops", message: "É necessário informar um sobrenome para o autor", in: self)
            return nil
        }
        
        guard let bio = self.bioTextView.text, !bio.isEmpty else {
            Alert.show(title: "Ops", message: "O campo bio é obrigatório", in: self)
            return nil
        }
        
        return AuthorRequest(fullName: fullName, bio: bio, profilePicturePath: pictureURL, technologies: self.technologiesTextField.text)
    }
    
    @objc func authorAddingButtonPressed(_ sender: UIButton!) {
        guard let author = getAuthorFromForm() else { return }
        
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        AuthorRepository().saveNew(author: author) { savedAuthor in
            indicator.stopAnimating()
            self.navigationController?.popViewController(animated: true)
            
            self.delegate?.didAuthorCreated(savedAuthor)
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to save new author. Try again!", in: self)
        }

    }
}
