//
//  BookDetailsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/05/21.
//

import UIKit
import AlamofireImage

protocol BookDetailsViewControllerDelegate: UIViewController {
    func didDeletingButtonPressed(_ sender: UIButton!, forBookIdentifiedBy id: Int)
}

class BookDetailsViewController: UIViewController {
    
    // MARK: Attributes
    
    var selectedBook: BookResponse?
    weak var delegate: BookDetailsViewControllerDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var ebookPrice: UILabel!
    @IBOutlet weak var hardcoverPrice: UILabel!
    @IBOutlet weak var comboPrice: UILabel!
    
    @IBOutlet weak var contentSectionTitle: SectionTitle!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var authorSectionTitle: SectionTitle!
    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorBioText: UITextView!
    
    @IBOutlet weak var productInfoSectionTitle: SectionTitle!
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var numberOfPagesLabel: UILabel!
    @IBOutlet weak var ISBNLabel: UILabel!
    
    @IBOutlet weak var deletingButton: UIButton!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        if let selectedBook = selectedBook {
            buildUp(using: selectedBook)
        }
    }
    
    private func adjustLayout() {
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
        
        contentSectionTitle.useTextColor()
        
        authorSectionTitle.useTextColor()
        authorImageView.roundTheShape()
        
        productInfoSectionTitle.useTextColor()
        
        let deletingButtonImage = UIImage(named: "trash")?.withTintColor(UIColor.white)
        deletingButton.setImage(deletingButtonImage, for: .normal)
        deletingButton.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        deletingButton.roundTheShape()
    }
    
    private func buildUp(using book: BookResponse) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
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
        
        contentSectionTitle.label.text = "Conteúdo"
        contentTextView.text = book.description
        
        authorSectionTitle.label.text = "Autor"
        authorImageView.af.setImage(withURL: book.author.profilePicturePath)
        authorNameLabel.text = book.author.fullName
        authorBioText.text = book.author.bio
        
        productInfoSectionTitle.label.text = "Dados do Produto"
        publicationDateLabel.text = book.publicationDate
        numberOfPagesLabel.text = String(describing: book.numberOfPages)
        ISBNLabel.text = book.ISBN
        
        deletingButton.addTarget(self, action: #selector(deletingButtonPressed(_:)), for: .touchUpInside)
        
        adjustLayout()
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
}
