//
//  ShowcaseBookCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import UIKit
import AlamofireImage

class ShowcaseBookCell: UICollectionViewCell, ReusableView {
    
    // MARK: IBOutlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    func setFrom(_ showcaseBook: BookResponse) {
        coverImageView.af.setImage(withURL: showcaseBook.coverImagePath)
        bookTitleLabel.text = showcaseBook.title
    }
}
