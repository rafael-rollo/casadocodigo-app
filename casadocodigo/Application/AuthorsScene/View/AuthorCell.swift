//
//  AuthorCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit
import AlamofireImage

protocol AuthorCellDelegate: UIViewController {
    func didRemovingButtonPressed(_ sender: UIButton!, forAuthorIdentifiedBy id: Int)
    func didEditingButtonPressed(_ sender: UIButton!, for author: AuthorResponse)
}

class AuthorCell: UICollectionViewCell, ReusableView {
    
    // MARK: Attributes
    
    var actionsTarget: AuthorResponse?
    weak var delegate: AuthorCellDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorPictureView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorRemovingButton: AuthorizedButton!
    @IBOutlet weak var authorEditingButton: AuthorizedButton!
    
    @IBOutlet weak var publicationCountLabel: UILabel!
    @IBOutlet weak var technologiesList: TagsHorizontalList!

    @IBOutlet weak var authorBioLabel: UILabel!
    
    // MARK: View methods
    
    private func configureCellBorders() {
        layer.cornerRadius = 8
        self.dropShadow()
    }

    private func adjustGeneralLayout() {
        configureCellBorders()
        authorPictureView.roundTheShape()
        
        let removingButtonImage = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        authorRemovingButton.setImage(removingButtonImage, for: .normal)
        authorRemovingButton.setVisibleOnly(to: Role.ADMIN)
        
        let editingButtonImage = UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate)
        authorEditingButton.setImage(editingButtonImage, for: .normal)
        authorEditingButton.setVisibleOnly(to: Role.ADMIN)
    }

    func setFrom(_ author: AuthorResponse) {
        adjustGeneralLayout()
        
        authorPictureView.af.setImage(withURL: author.profilePicturePath)
        authorNameLabel.text = author.fullName
        
        authorRemovingButton.addTarget(self, action: #selector(removingButtonPressed(_:)), for: .touchUpInside)
        authorEditingButton.addTarget(self, action: #selector(editingButtonPressed(_:)), for: .touchUpInside)
        
        publicationCountLabel.text = "Livros publicados \(author.publishedBooks)"
        technologiesList.setFrom(author.technologies)
        authorBioLabel.text = "\"\(author.bio)\""
        
        actionsTarget = author
    }
    
    // MARK: View callbacks
    
    @objc func removingButtonPressed(_ sender: UIButton!) {
        guard let currentAuthor = actionsTarget, let delegate = delegate else {
            debugPrint("Could not determine the target author for that action or the delegate instance. Check the method 'cellForItemAt' it sets up the author cells")
            return
        }
        
        ConfirmationDialog.execute(in: delegate, title: "Está certo disso?",
            message: "Você está removendo \(currentAuthor.fullName) da base de autores. Todos os livros do autor também serão removidos.") { action in
            self.delegate?.didRemovingButtonPressed(sender, forAuthorIdentifiedBy: currentAuthor.id)
        }
    }
    
    @objc func editingButtonPressed(_ sender: UIButton!) {
        guard let currentAuthor = actionsTarget else {
            debugPrint("Could not determine the target author for that action. Check the method 'cellForItemAt' it sets up the author cells")
            return
        }
        
        self.delegate?.didEditingButtonPressed(sender, for: currentAuthor)
    }

}
