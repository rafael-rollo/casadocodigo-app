//
//  NewAuthorViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 23/04/21.
//

import UIKit

class NewAuthorViewController: UIViewController {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var addAuthorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.configure(navigationController, current: self)
    
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        adjustLayout()
    }
    
    private func adjustLayout() {
        self.sectionTitle.label.text = "Novo autor"
        
        self.bioTextView.layer.cornerRadius = 6
        self.bioTextView.layer.borderWidth = 0.2
        self.bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.addAuthorButton.layer.masksToBounds = false
        self.addAuthorButton.layer.cornerRadius = 10
    }
}
