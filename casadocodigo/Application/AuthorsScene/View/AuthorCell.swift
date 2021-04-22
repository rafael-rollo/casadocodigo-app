//
//  AuthorCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit
import AlamofireImage

class AuthorCell: UICollectionViewCell {
    
    @IBOutlet weak var authorPictureView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var publicationCountLabel: UILabel!
    @IBOutlet weak var technologiesList: TagsHorizontalList!
    
    @IBOutlet weak var authorBioLabel: UILabel!

    func setFrom(_ author: Author) {
        configureBorders()
        
        self.authorPictureView.af.setImage(withURL: author.profilePicturePath)
        roundShape(for: self.authorPictureView)
        
        self.authorNameLabel.text = author.fullName
        self.publicationCountLabel.text = "Livros publicados \(author.publishedBooks)"
        
        self.technologiesList.setFrom(author.technologies)
        self.authorBioLabel.text = "\"\(author.bio)\""
    }
    
    private func roundShape(for view: UIView) {
        view.layer.cornerRadius = view.bounds.width / 2
    }
    
    private func configureBorders() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 0.2
        self.layer.borderColor = UIColor.lightGray.cgColor
    
        self.dropShadow()
    }
}
