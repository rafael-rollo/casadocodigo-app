//
//  ShowcaseBookCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import UIKit
import AlamofireImage

class ShowcaseBookCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setFrom(_ showcaseBook: BookShowcaseItem) {
        coverImageView.af.setImage(withURL: showcaseBook.coverImagePath)
        titleLabel.text = showcaseBook.title
    }
}
