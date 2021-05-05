//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit

class BookFormViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        buildUp()
    }
    
    private func buildUp() {
        sectionTitle.label.text = "Novo Livro"
    }

}
