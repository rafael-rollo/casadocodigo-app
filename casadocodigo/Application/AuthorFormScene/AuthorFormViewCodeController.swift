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

class AuthorFormViewCodeController: AuthorizedViewController {
    
    // MARK: - Attributes
    
    weak var delegate: AuthorFormViewControllerDelegate?
    private var authorRepository: AuthorRepository
    
    var selectedAuthor: AuthorResponse?
    var activeField: UITextField?
    var validator = Validator()
    
    // MARK: - Views
    
    private lazy var sectionTitle: SectionTitle = {
        let sectionTitle = SectionTitle()
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        return sectionTitle
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(x: 0, y: 0, width: 200, height: 200)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "avatar")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        return view
    }()
    
    private lazy var picturePathInputView: ValidatedTextInput = {
        let input = ValidatedTextInput()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.editingDidEnd = pictureFieldEditingDidEnd
        input.config(title: "Foto:",
                     placeholder: "https://filestoragedomain/picture.jpg",
                     rules: [.notEmpty, .validURL])
        validator.requireValidation(on: input)
        return input
    }()
    
    private lazy var nameInputView: ValidatedTextInput = {
        let input = ValidatedTextInput()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.config(title: "Nome:",
                     placeholder: "Autor do Livro",
                     rules: [.notEmpty, .validFullName])
        validator.requireValidation(on: input)
        return input
    }()
    
    private lazy var bioInputView: ValidatedLargeTextInput = {
        let input = ValidatedLargeTextInput()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.config(title: "Bio:",
                     placeholder: "Descreva o autor em algumas palavras",
                     rules: [.notEmpty, .minLength(100)])
        validator.requireValidation(on: input)
        return input
    }()
    
    private lazy var technologiesInputView: ValidatedTextInput = {
        let input = ValidatedTextInput()
        input.translatesAutoresizingMaskIntoConstraints = false
        input.config(title: "Tecnologias:",
                     placeholder: "Java; JavaScript; Spring; React Native; iOS",
                     rules: [.notEmpty])
        validator.requireValidation(on: input)
        return input
    }()
    
    private lazy var saveAuthorButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "skyBlue")
        button.layer.cornerRadius = 10
        button.showsTouchWhenHighlighted = true
        button.setTitle("Salvar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sectionTitle,
            imageContainer,
            picturePathInputView,
            nameInputView,
            bioInputView,
            technologiesInputView,
            saveAuthorButton
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: Theme.spacing.small,
            left: Theme.spacing.small,
            bottom: Theme.spacing.small,
            right: Theme.spacing.small
        )
        stackView.spacing = Theme.spacing.medium
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        return view
    }()
    
    private lazy var scrollView: KeyboardAvoidableView = {
        let scrollView = KeyboardAvoidableView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardAvoidableViewDelegate = self
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    // MARK: - Constructors
    
    init(authorRepository: AuthorRepository = AuthorRepository()) {
        self.authorRepository = authorRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func authorizedRoles() -> [Role] {
        return [Role.ADMIN]
    }
    
    // MARK: - View Lifecycle
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        if let selectedAuthor = self.selectedAuthor {
            sectionTitle.setText("Dados do autor")
            saveAuthorButton.addTarget(self,
                                       action: #selector(authorEditingButtonPressed(_:)),
                                       for: .touchUpInside)
            initViews(with: selectedAuthor)
        
        } else {
            sectionTitle.setText("Novo autor")
            saveAuthorButton.addTarget(self,
                                       action: #selector(authorAddingButtonPressed(_:)),
                                       for: .touchUpInside)
        }
    }
    
    private func initViews(with selectedAuthor: AuthorResponse) {
        picturePathInputView.setText(selectedAuthor.profilePicturePath.absoluteString)
        pictureFieldEditingDidEnd(picturePathInputView.getText()!)
        
        nameInputView.setText(selectedAuthor.fullName)
        bioInputView.setText(selectedAuthor.bio)
        technologiesInputView.setText(selectedAuthor.technologies.joined(separator: "; "))
    }
    
    // MARK: - Actions
    
    func pictureFieldEditingDidEnd(_ picturePath: String) {
        guard !picturePath.isEmpty else { return }
        
        guard let pictureURL = URL(string: picturePath) else { return }
        
        profileImageView.af.setImage(withURL: pictureURL)
    }
    
    private func getAuthorFromForm() -> AuthorRequest? {
        guard validator.isFormValid() else {
            return nil
        }
        
        return AuthorRequest(fullName: nameInputView.getText()!,
                             bio: bioInputView.getText()!,
                             profilePicturePath: picturePathInputView.getText()!,
                             technologies: technologiesInputView.getText()!)
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

extension AuthorFormViewCodeController: KeyboardAvoidableViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}

extension AuthorFormViewCodeController: ViewCode {
    func addViews() {
        view.addSubview(scrollView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let contentViewBottomConstraint = contentView.bottomAnchor
            .constraint(equalTo: scrollView.bottomAnchor)
        contentViewBottomConstraint.priority = .defaultLow
        
        let contentViewCenterYConstraint = contentView.centerYAnchor
            .constraint(equalTo: scrollView.centerYAnchor)
        contentViewCenterYConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentViewBottomConstraint,
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentViewCenterYConstraint
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sectionTitle.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 200),
            profileImageView.widthAnchor.constraint(equalToConstant: 200),
            profileImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            profileImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            saveAuthorButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    func addTheme() {
        view.backgroundColor = .white
    }
}
