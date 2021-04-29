//
//  AuthorCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit
import AlamofireImage

protocol AuthorCellDelegate {
    func didRemovingButtonPressed(_ sender: UIButton!, forAuthorIdentifiedBy id: Int)
}

class AuthorCell: UICollectionViewCell, ReusableView {
    
    // MARK: Attributes
    
    var delegate: AuthorCellDelegate?
    var actionsTarget: AuthorResponse?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorPictureView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorRemovingButton: UIButton!
    
    @IBOutlet weak var publicationCountLabel: UILabel!
    @IBOutlet weak var technologiesList: TagsHorizontalList!

    @IBOutlet weak var authorBioLabel: UILabel!
    
    // MARK: View methods
    
    private func configureCellBorders() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.lightGray.cgColor
    
        self.dropShadow()
    }

    private func adjustGeneralLayout() {
        configureCellBorders()
        authorPictureView.roundTheShape()
        
        let removingButtonImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        authorRemovingButton.setImage(removingButtonImage, for: .normal)
    }

    func setFrom(_ author: AuthorResponse) {
        adjustGeneralLayout()
        
        authorPictureView.af.setImage(withURL: author.profilePicturePath)
        authorNameLabel.text = author.fullName
        
        authorRemovingButton.addTarget(self, action: #selector(removingButtonPressed(_:)), for: .touchUpInside)
        
        publicationCountLabel.text = "Livros publicados \(author.publishedBooks)"
        technologiesList.setFrom(author.technologies)
        authorBioLabel.text = "\"\(author.bio)\""
        
        actionsTarget = author
    }
    
    // MARK: View callbacks
    
    @objc func removingButtonPressed(_ sender: UIButton!) {
        guard let currentAuthor = self.actionsTarget else {
            debugPrint("Could not determine the target author for that action. Check the method 'cellForItemAt' it sets up the author cells")
            return
        }
        
        let parentController = self.delegate as! UIViewController
        
        ConfirmationDialog.execute(in: parentController, title: "Está certo disso?",
            message: "Você está removendo \(currentAuthor.fullName) da base de autores. Todos os livros do autor também serão removidos.") { (action) in
            self.delegate?.didRemovingButtonPressed(sender, forAuthorIdentifiedBy: currentAuthor.id)
        }
    }

}
