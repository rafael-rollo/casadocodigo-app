//
//  BookDetailsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/05/21.
//

import UIKit
import AlamofireImage

class BookDetailsViewController: UIViewController {
    
    var selectedBook: BookResponse?
    
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
    
    @IBOutlet weak var productInfoSectionTitle: SectionTitle!
    @IBOutlet weak var numberOfPagesLabel: UILabel!
    @IBOutlet weak var ISBNLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        if let selectedBook = selectedBook {
            buildUp(using: selectedBook)
        }
    }
    
    private func adjustLayout() {
        contentSectionTitle.useTextColor()
        authorSectionTitle.useTextColor()
        productInfoSectionTitle.useTextColor()
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
        
        productInfoSectionTitle.label.text = "Dados do Produto"
        numberOfPagesLabel.text = String(describing: book.numberOfPages)
        ISBNLabel.text = book.ISBN
        
        adjustLayout()
    }
}
