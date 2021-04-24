//
//  NewAuthorViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 23/04/21.
//

import UIKit

class NewAuthorViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationBar.configure(navigationController, current: self)
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
    }

}
