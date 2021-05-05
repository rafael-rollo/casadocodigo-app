//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit

class BookFormViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
    }

}
