//
//  BookDetailsViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/05/21.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    var selectedBook: BookShowcaseItem?
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        if let book = selectedBook {
            titleLabel.text = book.title
        }
    }
}
