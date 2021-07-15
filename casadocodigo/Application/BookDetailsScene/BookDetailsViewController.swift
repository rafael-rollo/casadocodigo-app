//
//  BookDetailsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/05/21.
//

import UIKit
import AlamofireImage

protocol BookDetailsViewControllerDelegate: BaseNavbarItemsViewController {
    func didDeletingButtonPressed(_ sender: UIButton!, forBookIdentifiedBy id: Int)
    func didEditingButtonPressed(_ sender: UIButton!, for book: BookResponse)
}

class BookDetailsViewController: BaseNavbarItemsViewController {
    
    // MARK: Attributes
    
    var selectedBook: BookResponse?
    weak var delegate: BookDetailsViewControllerDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var ebookPrice: UILabel!
    @IBOutlet weak var hardcoverPrice: UILabel!
    @IBOutlet weak var comboPrice: UILabel!
    
    @IBOutlet weak var buyEbookButton: AuthorizedButton!
    @IBOutlet weak var buyHardCoverButton: AuthorizedButton!
    @IBOutlet weak var buyComboButton: AuthorizedButton!
    
    @IBOutlet weak var contentSectionTitle: SectionTitle!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var authorSectionTitle: SectionTitle!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var regularWidthAuthorBioText: UILabel!
    @IBOutlet weak var authorBioText: UITextView!
    
    @IBOutlet weak var productInfoSectionTitle: SectionTitle!
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var numberOfPagesLabel: UILabel!
    @IBOutlet weak var ISBNLabel: UILabel!
    
    @IBOutlet weak var deletingButton: AuthorizedButton!
    @IBOutlet weak var editingButton: AuthorizedButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
        setup()
    }
    
    override func didUserSignedIn() {
        super.didUserSignedIn()
        
        setup()
    }
    
    fileprivate func setup() {
        if let selectedBook = selectedBook {
            setupViews(with: selectedBook)
        }
    }
        
    fileprivate func setupViews(with book: BookResponse) {
        titleLabel.text = book.title
        titleLabel.sizeToFit()
        
        subtitleLabel.text = book.subtitle
        subtitleLabel.sizeToFit()
        
        coverImageView.af.setImage(withURL: book.coverImagePath)
        
        book.prices.forEach { price in
            switch price.bookType {
            case .ebook:
                ebookPrice.text = price.value.currencyValue()
            
            case .hardCover:
                hardcoverPrice.text = price.value.currencyValue()
                
            case .combo:
                comboPrice.text = price.value.currencyValue()
            }
        }
        [buyEbookButton, buyHardCoverButton, buyComboButton]
            .forEach { $0?.setHidden(for: Role.ADMIN) }
        
        contentSectionTitle.setText("Conteúdo")
        contentSectionTitle.useTextColor()
        contentTextView.text = book.description
        
        authorSectionTitle.setText("Autor")
        authorSectionTitle.useTextColor()
        
        authorImageView.af.setImage(withURL: book.author.profilePicturePath)
        authorImageView.roundTheShape()
        
        authorNameLabel.text = book.author.fullName
        
        let authorBio = book.author.bio
        authorBioText.text = authorBio
        regularWidthAuthorBioText.text = authorBio
        
        setupAuthorBio(with: traitCollection)
        
        productInfoSectionTitle.setText("Dados do Produto")
        productInfoSectionTitle.useTextColor()
        
        publicationDateLabel.text = book.publicationDate
        numberOfPagesLabel.text = String(describing: book.numberOfPages)
        ISBNLabel.text = book.ISBN
        
        let deletingButtonImage = UIImage(named: "trash")?.withTintColor(UIColor.white)
        deletingButton.setImage(deletingButtonImage, for: .normal)
        deletingButton.addTarget(self, action: #selector(deletingButtonPressed(_:)), for: .touchUpInside)
        deletingButton.roundTheShape()
        deletingButton.setVisibleOnly(to: Role.ADMIN)
        
        let editingButtonImage = UIImage(named: "pencil")?.withTintColor(UIColor.white)
        editingButton.setImage(editingButtonImage, for: .normal)
        editingButton.addTarget(self, action: #selector(editingButtonPressed(_:)), for: .touchUpInside)
        editingButton.roundTheShape()
        editingButton.setVisibleOnly(to: Role.ADMIN)
    }
    
    fileprivate func setupAuthorBio(with traits: UITraitCollection) {
        regularWidthAuthorBioText.isHidden = traits.horizontalSizeClass == .compact
        authorBioText.isHidden = !regularWidthAuthorBioText.isHidden
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        let widthSizeClassChanged = traitCollection.horizontalSizeClass
            != previousTraitCollection?.horizontalSizeClass
        
        guard widthSizeClassChanged else { return }
        
        setupAuthorBio(with: traitCollection)
    }
    
    // MARK: Actions
    
    @objc func deletingButtonPressed(_ sender: UIButton!) {
        guard let selectedBook = selectedBook else {
            debugPrint("Could not determine the target book for that action. Check the method 'didSelectItemAt' it sets up the book details requirements")
            return
        }
        
        ConfirmationDialog.execute(in: self, title: "Está certo disso?",
            message: "Você está removendo o livro \"\(selectedBook.title)\".") { action in
            
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didDeletingButtonPressed(sender, forBookIdentifiedBy: selectedBook.id)
        }
    }
    
    @objc func editingButtonPressed(_ sender: UIButton!) {
        guard let selectedBook = selectedBook else {
            debugPrint("Could not determine the target book for that action. Check the method 'didSelectItemAt' it sets up the book details requirements")
            return
        }
        
        self.delegate?.didEditingButtonPressed(sender, for: selectedBook)
    }
}
