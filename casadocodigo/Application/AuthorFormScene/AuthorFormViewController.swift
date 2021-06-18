//
//  AuthorFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 23/04/21.
//

import UIKit
import AlamofireImage

protocol AuthorFormViewControllerDelegate: AnyObject {
    func didAuthorCreated(_ author: AuthorResponse)
    func didAuthorUpdated(_ author: AuthorResponse)
}

class AuthorFormViewController: AuthorizedViewController {
    
    // MARK: Attributes
    weak var delegate: AuthorFormViewControllerDelegate?
    var activeField: UITextField?
    
    private var authorRepository: AuthorRepository
    var selectedAuthor: AuthorResponse?
    
    // MARK: IBOutlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sectionTitle: SectionTitle!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var pictureUrlTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var technologiesTextField: UITextField!
    @IBOutlet weak var saveAuthorButton: UIButton!
    
    // MARK: Constructors
    
    init(authorRepository: AuthorRepository = AuthorRepository()) {
        self.authorRepository = authorRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.authorRepository = AuthorRepository()
        super.init(coder: coder)
    }
    
    override func authorizedRoles() -> [Role] {
        return [Role.ADMIN]
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        buildUp()
    }
    
    private func buildUp() {
        if let selectedAuthor = self.selectedAuthor {
            self.sectionTitle.label.text = "Dados do autor"
            self.saveAuthorButton.addTarget(self, action: #selector(authorEditingButtonPressed(_:)), for: .touchUpInside)
            
            self.initData(with: selectedAuthor)
        } else {
            self.sectionTitle.label.text = "Novo autor"
            self.saveAuthorButton.addTarget(self, action: #selector(authorAddingButtonPressed(_:)), for: .touchUpInside)
        }
        
        adjustLayout()
    }
    
    private func initData(with selectedAuthor: AuthorResponse) {
        pictureUrlTextField.text = selectedAuthor.profilePicturePath.absoluteString
        pictureFieldEditingDidEnd(pictureUrlTextField)
        
        nameTextField.text = selectedAuthor.fullName
        bioTextView.text = selectedAuthor.bio
        technologiesTextField.text = selectedAuthor.technologies.joined(separator: "; ")
    }

    private func adjustLayout() {
        profilePictureView.roundTheShape()
        bioTextView.configureBorders()
        
        saveAuthorButton.layer.cornerRadius = 10
        saveAuthorButton.showsTouchWhenHighlighted = true
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                                as! NSValue).cgRectValue.height
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var referenceRect = self.view.frame
        referenceRect.size.height -= keyboardHeight
        
        guard let activeField = activeField else { return }
        
        if !referenceRect.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // MARK: IBActions
    
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
        
        authorRepository.saveNew(author: author) { [weak self] savedAuthor in
            indicator.stopAnimating()
            self?.navigationController?.popViewController(animated: true)
            
            self?.delegate?.didAuthorCreated(savedAuthor)
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to save new author. Try again!", in: self)
        }

    }
    
    @objc func authorEditingButtonPressed(_ sender: UIButton!) {
        guard let selectedAuthor = self.selectedAuthor else {
            fatalError("Could not possible to perform that action because an illegal state was verified. A selected author is required at this point.")
        }
        
        guard let author = getAuthorFromForm() else { return }
        
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        authorRepository.update(author, identifiedBy: selectedAuthor.id) { [weak self] updatedAuthor in
            indicator.stopAnimating()
            self?.navigationController?.popViewController(animated: true)
            
            self?.delegate?.didAuthorUpdated(updatedAuthor)
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to update author data. Try again!", in: self)
        }
    }
}

extension AuthorFormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
