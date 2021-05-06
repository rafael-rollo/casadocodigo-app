//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit
import AlamofireImage

protocol BookFormViewControllerDelegate: class {
    func didBookCreated(_ book: BookResponse)
}

class BookFormViewController: UIViewController {
    
    // MARK: Attributes
    
    var authors: [AuthorResponse] = []
    
    var authorRepository: AuthorRepository
    var bookRepository: BookRepository
    
    weak var delegate: BookFormViewControllerDelegate?

    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverPathTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    
    @IBOutlet weak var ebookPriceField: UITextField!
    @IBOutlet weak var hardcoverPriceField: UITextField!
    @IBOutlet weak var comboPriceField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var authorTextField: UITextField!
    var authorPickerView = UIPickerView()
    
    @IBOutlet weak var publicationDateTextField: UITextField!
    @IBOutlet weak var pagesTextField: UITextField!
    @IBOutlet weak var ISBNTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: Initializers
    
    init(authorRepository: AuthorRepository = AuthorRepository(),
         bookRepository: BookRepository = BookRepository(),
         nibName: String? = nil, bundle: Bundle? = nil) {
        self.authorRepository = authorRepository
        self.bookRepository = bookRepository
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        self.authorRepository = AuthorRepository()
        self.bookRepository = BookRepository()
        super.init(coder: coder)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorPickerView.dataSource = self
        authorPickerView.delegate = self
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        loadAuthors()
        buildUp()
    }
    
    private func adjustLayout() {
        descriptionTextView.configureBorders()
        
        authorTextField.inputView = authorPickerView
        
        submitButton.layer.cornerRadius = 10
        submitButton.showsTouchWhenHighlighted = true
    }
    
    private func buildUp() {
        sectionTitle.label.text = "Novo Livro"
        
        submitButton.addTarget(self,
                               action: #selector(bookAddingButtonPressed(_:)),
                               for: .touchUpInside)
        adjustLayout()
    }

    // MARK: IBActions
    
    @IBAction func coverFieldEditingDidEnd(_ sender: Any) {
        guard let coverPathAsString = coverPathTextField.text,
              !coverPathAsString.isEmpty else { return }
        
        guard let coverUri = URL(string: coverPathAsString) else { return }
        
        coverImageView.af.setImage(withURL: coverUri)
    }
    
    @IBAction func didPublicationDateFieldFocused(_ sender: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.addTarget(self, action: #selector(updatePublicationDateFieldValue(_:)), for: .valueChanged)
        
        if let publicationDate = publicationDateTextField.text, publicationDate.isEmpty {
            updatePublicationDateFieldValue(datePicker)
        }
        
        publicationDateTextField.inputView = datePicker
    }
    
    @objc func updatePublicationDateFieldValue(_ sender: UIDatePicker!) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        publicationDateTextField.text = formatter.string(from: sender.date)
    }
    
    /**
     Tem que ter um jeito mais fácil de fazer isso 😢
     */
    private func getBookFromForm() -> BookRequest? {
        guard let coverURI = coverPathTextField.text, !coverURI.isEmpty else {
            Alert.show(title: "Ops", message: "Adicione uma URI válida para a imagem da capa do livro.", in: self)
            return nil
        }
        
        guard let title = titleTextField.text, !title.isEmpty else {
            Alert.show(title: "Ops", message: "O título do livro é obrigatório!", in: self)
            return nil
        }
        
        guard let subtitle = subtitleTextField.text, !subtitle.isEmpty else {
            Alert.show(title: "Ops", message: "O subtítulo do livro é obrigatório!", in: self)
            return nil
        }
        
        guard let ebookPriceAsString = ebookPriceField.text, !ebookPriceAsString.isEmpty,
              let ebookPrice = Decimal(string: ebookPriceAsString) else {
            Alert.show(title: "Ops", message: "Informe um preço válido para a versão eBook!", in: self)
            return nil
        }
        
        guard let hardcoverPriceAsString = hardcoverPriceField.text, !hardcoverPriceAsString.isEmpty,
              let hardcoverPrice = Decimal(string: hardcoverPriceAsString) else {
            Alert.show(title: "Ops", message: "Informe um preço válido para a versão impressa!", in: self)
            return nil
        }
        
        guard let comboPriceAsString = comboPriceField.text, !comboPriceAsString.isEmpty,
              let comboPrice = Decimal(string: comboPriceAsString) else {
            Alert.show(title: "Ops", message: "Informe um preço válido para o combo eBook + impresso!", in: self)
            return nil
        }
        
        guard let description = descriptionTextView.text, !description.isEmpty else {
            Alert.show(title: "Ops", message: "Adicione o conteúdo descritivo do livro!", in: self)
            return nil
        }
        
        let selectedRow = authorPickerView.selectedRow(inComponent: 0)
        let authorId = authors[selectedRow].id
        
        guard let publicationDate = publicationDateTextField.text, !publicationDate.isEmpty else {
            Alert.show(title: "Ops", message: "Informe a data de publicação do livro.", in: self)
            return nil
        }
        
        guard let pagesAsString = pagesTextField.text, !pagesAsString.isEmpty,
              let numberOfPages = Int(pagesAsString) else {
            Alert.show(title: "Ops", message: "Informe um número de páginas válido para o livro!", in: self)
            return nil
        }
        
        guard let ISBN = ISBNTextField.text, !ISBN.isEmpty else {
            Alert.show(title: "Ops", message: "O número de ISBN é obrigatório.", in: self)
            return nil
        }
        
        return BookRequest(title: title, subtitle: subtitle, coverImagePath: coverURI, eBookPrice: ebookPrice, hardcoverPrice: hardcoverPrice, comboPrice: comboPrice, description: description, authorId: authorId, publicationDate: publicationDate, numberOfPages: numberOfPages, ISBN: ISBN)
    }
    
    @objc func bookAddingButtonPressed(_ sender: UIButton!) {
        guard let book = getBookFromForm() else { return }
        
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        bookRepository.saveNew(book) { [weak self] (createdBook) in
            guard let self = self else { return }
       
            indicator.stopAnimating()
            
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didBookCreated(createdBook)
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to save that book right now. Try again later!", in: self)
        }

    }
    
    // MARK: View methods
    
    func updateAuthors(with authors: [AuthorResponse]) {
        self.authors = authors
        
        guard let firstAuthor = authors.first else { return }
        
        authorPickerView.selectRow(0, inComponent: 0, animated: false)
        authorTextField.text = firstAuthor.fullName
    }
    
    func loadAuthors() {
        authorRepository.allAuthors { [weak self] loadedAuthors in
            guard let self = self else { return }
            self.updateAuthors(with: loadedAuthors)
            
        } failureHandler: {
            Alert.show(title: "Ops", message: "Could not possible to load our authors", in: self)
        }
    }
}

extension BookFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // single picker component
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return authors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return authors[row].fullName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        authorTextField.text = authors[row].fullName
        authorTextField.resignFirstResponder()
    }
}
