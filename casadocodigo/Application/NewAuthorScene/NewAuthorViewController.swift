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
        navigationBar.configure(navigationController, current: self)
    
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        adjustLayout()
    }
    
    private func adjustLayout() {
        sectionTitle.label.text = "Novo autor"
        
        profilePictureView.roundTheShape()
        
        bioTextView.layer.cornerRadius = 6
        bioTextView.layer.borderWidth = 0.2
        bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        addAuthorButton.layer.cornerRadius = 10
        addAuthorButton.showsTouchWhenHighlighted = true
        addAuthorButton.addTarget(self, action: #selector(authorAddingButtonPressed(_:)), for: .touchUpInside)
    }
    
    @IBAction func pictureFieldEditingDidEnd(_ sender: UITextField) {
        guard let pictureURLAsString = pictureUrlTextField.text,
              !pictureURLAsString.isEmpty else { return }
        
        guard let pictureURL = URL(string: pictureURLAsString) else { return }
        
        profilePictureView.af.setImage(withURL: pictureURL)
    }
    
    private func getAuthorFromForm() -> AuthorRequest? {
        guard let pictureURL = pictureUrlTextField.text, !pictureURL.isEmpty else {
            Alert.show(title: "Ops", message: "Adicione uma URL válida para a foto de perfil do autor", in: self)
            return nil
        }
        
        guard let fullName = nameTextField.text, !fullName.isEmpty else {
            Alert.show(title: "Ops", message: "O campo nome é obrigatório", in: self)
            return nil
        }
        
        guard fullName.components(separatedBy: " ").count >= 2 else {
            Alert.show(title: "Ops", message: "É necessário informar um sobrenome para o autor", in: self)
            return nil
        }
        
        guard let bio = bioTextView.text, !bio.isEmpty else {
            Alert.show(title: "Ops", message: "O campo bio é obrigatório", in: self)
            return nil
        }
        
        return AuthorRequest(fullName: fullName, bio: bio, profilePicturePath: pictureURL, technologies: technologiesTextField.text)
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
