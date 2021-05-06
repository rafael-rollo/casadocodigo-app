//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit
import AlamofireImage

class BookFormViewController: UIViewController {
    
    // MARK: Attributes
    
    var authors: [AuthorResponse] = []
    var authorRepository: AuthorRepository

    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverPathTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var authorTextField: UITextField!
    var authorPickerView = UIPickerView()
    
    @IBOutlet weak var publicationDateTextField: UITextField!
    
    // MARK: Initializers
    
    init(authorRepository: AuthorRepository = AuthorRepository(), nibName: String? = nil, bundle: Bundle? = nil) {
        self.authorRepository = authorRepository
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        self.authorRepository = AuthorRepository()
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
    }
    
    private func buildUp() {
        sectionTitle.label.text = "Novo Livro"
        
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
