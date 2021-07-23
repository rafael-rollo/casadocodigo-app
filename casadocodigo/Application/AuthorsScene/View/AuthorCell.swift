//
//  AuthorCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit
import AlamofireImage

protocol AuthorCellDelegate: UIViewController {
    func didRemovingButtonPressed(_ sender: UIAction!, forAuthorIdentifiedBy id: Int)
    func didEditingButtonPressed(_ sender: UIAction!, for author: AuthorResponse)
}

class AuthorCell: UICollectionViewCell, ReusableView {
    
    // MARK: Attributes
    
    var actionsTarget: AuthorResponse?
    weak var delegate: AuthorCellDelegate?
    
    var cornerRadius: CGFloat = 8.0
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit",
                     image: UIImage(systemName: "pencil"),
                     handler: { [weak self] action in
                        self?.editingButtonPressed(action)
                     }),
            UIAction(title: "Delete",
                     image: UIImage(systemName: "trash"),
                     attributes: .destructive,
                     handler: { [weak self] action in
                        self?.removingButtonPressed(action)
                     })
        ]
    }

    var authorMenu: UIMenu {
        return UIMenu(title: "Author Actions",
                      image: nil,
                      identifier: nil,
                      options: [],
                      children: menuItems)
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var authorPictureView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var authorMenuButton: AuthorizedButton!
    
    @IBOutlet weak var publicationCountLabel: UILabel!
    @IBOutlet weak var technologiesList: TagsHorizontalList!

    @IBOutlet weak var authorBioLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    fileprivate func setupViews() {
        authorPictureView.roundTheShape()
        
        authorMenuButton.menu = authorMenu
        authorMenuButton.showsMenuAsPrimaryAction = true
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.secondaryLabel.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        layoutAttributes.frame.size.height = ceil(size.height)

        layoutIfNeeded()
        return layoutAttributes
    }
    
    // MARK: - View methods
    
    func setFrom(_ author: AuthorResponse) {
        actionsTarget = author
        
        authorPictureView.af.setImage(withURL: author.profilePicturePath)
        authorNameLabel.text = author.fullName
        authorMenuButton.setVisibleOnly(to: Role.ADMIN)
        
        publicationCountLabel.text = String(author.publishedBooks)
        technologiesList.set(items: author.technologies)
        
        authorBioLabel.text = "\"\(author.bio)\""
        layoutIfNeeded()
    }
    
    // MARK: View callbacks
    
    @objc func removingButtonPressed(_ sender: UIAction!) {
        guard let currentAuthor = actionsTarget, let delegate = delegate else {
            debugPrint("Could not determine the target author for that action or the delegate instance. Check the method 'cellForItemAt' it sets up the author cells")
            return
        }
        
        ConfirmationDialog.execute(in: delegate, title: "Está certo disso?",
            message: "Você está removendo \(currentAuthor.fullName) da base de autores. Todos os livros do autor também serão removidos.") { action in
            self.delegate?.didRemovingButtonPressed(sender, forAuthorIdentifiedBy: currentAuthor.id)
        }
    }
    
    @objc func editingButtonPressed(_ sender: UIAction!) {
        guard let currentAuthor = actionsTarget else {
            debugPrint("Could not determine the target author for that action. Check the method 'cellForItemAt' it sets up the author cells")
            return
        }
        
        self.delegate?.didEditingButtonPressed(sender, for: currentAuthor)
    }

}
