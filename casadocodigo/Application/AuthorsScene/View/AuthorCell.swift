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
        
        authorPictureView.af.setImage(withURL: author.profilePicturePath)
        roundShape(for: authorPictureView)
        
        authorNameLabel.text = author.fullName
        publicationCountLabel.text = "Livros publicados \(author.publishedBooks)"
        
        technologiesList.setFrom(author.technologies)
        authorBioLabel.text = "\"\(author.bio)\""
    }
    
    private func roundShape(for view: UIView) {
        view.layer.cornerRadius = view.bounds.width / 2
    }
    
    private func configureBorders() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
    
        self.dropShadow()
    }
}
