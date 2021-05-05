//
//  BookDetailsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/05/21.
//

import UIKit
import AlamofireImage

class BookDetailsViewController: UIViewController {
    
    var selectedBook: BookShowcaseItem?
    
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        guard let selectedBook = selectedBook else { return }
        titleLabel.text = selectedBook.title
        coverImageView.af.setImage(withURL: selectedBook.coverImagePath)
    }
}
