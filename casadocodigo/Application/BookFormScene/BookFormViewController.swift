//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit
import AlamofireImage

protocol BookFormViewControllerDelegate: AnyObject {
    func didBookCreated(_ book: BookResponse)
    func didBookUpdated(_ book: BookResponse)
}

class BookFormViewController: AuthorizedViewController {

    // MARK: - Attributes
    
    var authors: [AuthorResponse] = []
    var selectedBook: BookResponse?
    
    var authorRepository: AuthorRepository
    var bookRepository: BookRepository
    
    weak var delegate: BookFormViewControllerDelegate?
    var activeField: UITextField?
    var validator: Validator = Validator()

    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: KeyboardAvoidableView!
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverPathInputView: ValidatedTextInput!
    
    @IBOutlet weak var titleInputView: ValidatedTextInput!
    @IBOutlet weak var subtitleInputView: ValidatedTextInput!
    
    @IBOutlet weak var eBookPriceInputView: ValidatedTextInput!
    @IBOutlet weak var hardcoverPriceInputView: ValidatedTextInput!
    @IBOutlet weak var comboPriceInputView: ValidatedTextInput!
    
    @IBOutlet weak var descriptionInputView: ValidatedLargeTextInput!
    
    @IBOutlet weak var authorTextField: UITextField!
    private var authorPickerView: UIPickerView?

    @IBOutlet weak var publicationDatePicker: UIDatePicker!
    private var publicationDate: String?
    
    @IBOutlet weak var pagesInputView: ValidatedTextInput!
    @IBOutlet weak var ISBNInputView: ValidatedTextInput!
    
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Initializers
    
    init(authorRepository: AuthorRepository = AuthorRepository(),
         bookRepository: BookRepository = BookRepository(),
         nibName: String? = nil,
         bundle: Bundle? = nil) {
        self.authorRepository = authorRepository
        self.bookRepository = bookRepository
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        self.authorRepository = AuthorRepository()
        self.bookRepository = BookRepository()
        super.init(coder: coder)
    }
    
    override func authorizedRoles() -> [Role] {
        return [Role.ADMIN]
    }
    
    // MARK: - View lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAuthors()
        initViews()
    }
    
    private func initViews() {
        scrollView.keyboardAvoidableViewDelegate = self
        
        coverPathInputView.editingDidEnd = coverFieldEditingDidEnd
        coverPathInputView.config(
            title: "Capa do Livro:",
            placeholder: "Digite a URI da capa do livro",
            rules: [.notEmpty, .validURL]
        )
        validator.requireValidation(on: coverPathInputView)
        
        titleInputView.config(
            title: "Título",
            placeholder: "Descreva aqui o título do livro",
            rules: [.notEmpty]
        )
        validator.requireValidation(on: titleInputView)
        
        subtitleInputView.config(
            title: "Subtítulo",
            placeholder: "Descreva aqui o subtítulo do livro",
            rules: [.notEmpty]
        )
        validator.requireValidation(on: subtitleInputView)
        
        eBookPriceInputView.config(
            title: "Preço do eBook:",
            placeholder: "29,90",
            keyboardType: .decimalPad,
            rules: [.minDecimal(19.9)]
        )
        validator.requireValidation(on: eBookPriceInputView)
        
        hardcoverPriceInputView.config(
            title: "Preço do Impresso:",
            placeholder: "39,90",
            keyboardType: .decimalPad,
            rules: [.minDecimal(19.9)]
        )
        validator.requireValidation(on: hardcoverPriceInputView)
        
        comboPriceInputView.config(
            title: "Preço do Combo:",
            placeholder: "59,90",
            keyboardType: .decimalPad,
            rules: [.minDecimal(19.9)]
        )
        validator.requireValidation(on: comboPriceInputView)
        
        descriptionInputView.config(
            title: "Conteúdo:",
            placeholder: "Descreva aqui o conteúdo deste livro",
            rules: [.minLength(100)]
        )
        validator.requireValidation(on: descriptionInputView)
        
        authorPickerView = UIPickerView()
        authorPickerView?.dataSource = self
        authorPickerView?.delegate = self
        authorTextField.inputView = authorPickerView
        
        publicationDatePicker.addTarget(self, action: #selector(updatePublicationDateValue(_:)), for: .valueChanged)
        updatePublicationDateValue(publicationDatePicker)
        
        pagesInputView.config(
            title: "Número de Páginas:",
            placeholder: "00",
            keyboardType: .numberPad,
            rules: [.min(50)]
        )
        validator.requireValidation(on: pagesInputView)
        
        ISBNInputView.config(
            title: "ISBN:",
            placeholder: "000-00-0000-000-0",
            rules: [.notEmpty, .validIsbnFormat]
        )
        validator.requireValidation(on: ISBNInputView)
        
        submitButton.layer.cornerRadius = 10
        submitButton.showsTouchWhenHighlighted = true
        
        guard let selectedBook = selectedBook else {
            sectionTitle.setText("Novo Livro")
            submitButton.addTarget(
                self,
                action: #selector(bookAddingButtonPressed(_:)),
                for: .touchUpInside
            )
            
            return
        }
    
        sectionTitle.setText("Dados do Livro")
        submitButton.addTarget(
            self,
            action: #selector(bookEdittingButtonPressed(_:)),
            for: .touchUpInside
        )
            
        initViews(with: selectedBook)
    }
    
    private func initViews(with book: BookResponse) {
        coverPathInputView.setText(book.coverImagePath.absoluteString)
        coverFieldEditingDidEnd(coverPathInputView.getText()!)
        
        titleInputView.setText(book.title)
        subtitleInputView.setText(book.subtitle)
        
        book.prices.forEach { price in
            let value = String(describing: price.value)
            
            switch price.bookType {
            case .ebook:
                eBookPriceInputView.setText(value)
            
            case .hardCover:
                hardcoverPriceInputView.setText(value)
            
            case .combo:
                comboPriceInputView.setText(value)
            }
        }
        
        descriptionInputView.setText(book.description)

        if let publicationDate = Date.fromString(book.publicationDate, formattedBy: "dd/MM/yyyy") {
            publicationDatePicker.setDate(publicationDate, animated: false)
            updatePublicationDateValue(publicationDatePicker)
        }
        
        pagesInputView.setText(String(describing: book.numberOfPages))
        ISBNInputView.setText(book.ISBN)
    }

    // MARK: - Actions
    
    func coverFieldEditingDidEnd(_ coverPath: String) {
        guard !coverPath.isEmpty else { return }
        
        guard let coverUri = URL(string: coverPath) else { return }
        
        coverImageView.af.setImage(withURL: coverUri)
    }
    
    @objc func updatePublicationDateValue(_ sender: UIDatePicker!) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        publicationDate = formatter.string(from: sender.date)
    }
    
    private func getBookFromForm() -> BookRequest? {
        guard validator.isFormValid() else {
            return nil
        }
        
        let ebookPrice = Decimal(string: eBookPriceInputView.getText()!)!
        let hardcoverPrice = Decimal(string: hardcoverPriceInputView.getText()!)!
        let comboPrice = Decimal(string: comboPriceInputView.getText()!)!
    
        guard let selectedRow = authorPickerView?.selectedRow(inComponent: 0) else { return nil }
        let authorId = authors[selectedRow].id
        
        let numberOfPages = Int(pagesInputView.getText()!)!
        
        return BookRequest(title: titleInputView.getText()!, subtitle: subtitleInputView.getText()!, coverImagePath: coverPathInputView.getText()!,
                           eBookPrice: ebookPrice, hardcoverPrice: hardcoverPrice, comboPrice: comboPrice,
                           description: descriptionInputView.getText()!, authorId: authorId,
                           publicationDate: publicationDate!, numberOfPages: numberOfPages, ISBN: ISBNInputView.getText()!)
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
    
    @objc func bookEdittingButtonPressed(_ sender: UIButton!) {
        guard let selectedBook = selectedBook else {
            fatalError("Could not possible to perform that action because an illegal state was verified. A selected book is required at this point.")
        }
        
        guard let book = getBookFromForm() else { return }
        
        let indicator = UIActivityIndicatorView.customIndicator(to: self.view)
        indicator.startAnimating()
        
        bookRepository.update(book, identifiedBy: selectedBook.id) { [weak self] updatedBook in
            indicator.stopAnimating()
            self?.navigationController?.popToRootViewController(animated: true)
            
            self?.delegate?.didBookUpdated(updatedBook)
            
        } failureHandler: {
            indicator.stopAnimating()
            Alert.show(title: "Ops", message: "Could not possible to update book data. Try again later!", in: self)
        }
    }
    
    // MARK: - View methods
    
    func updateAuthors(with authors: [AuthorResponse]) {
        self.authors = authors
        
        guard let firstAuthor = authors.first else { return }
        
        if let selectedBook = selectedBook {
            authors.enumerated().forEach { (index, author) in
                if selectedBook.author.id != author.id { return }
                
                authorPickerView?.selectRow(index, inComponent: 0, animated: false)
                authorTextField.text = selectedBook.author.fullName
            }
            
        } else {
            authorPickerView?.selectRow(0, inComponent: 0, animated: false)
            authorTextField.text = firstAuthor.fullName
        }
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

extension BookFormViewController: KeyboardAvoidableViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
