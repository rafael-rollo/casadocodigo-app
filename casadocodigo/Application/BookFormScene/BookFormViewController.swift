//
//  BookFormViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 05/05/21.
//

import UIKit
import AlamofireImage

class BookFormViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverPathTextField: UITextField!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusBarBackground(target: self.view).set(color: NavigationBar.COLOR)
        navigationBar.configure(navigationController, current: self)
        
        buildUp()
    }
    
    private func adjustLayout() {
        descriptionTextView.configureBorders()
    }
    
    private func buildUp() {
        sectionTitle.label.text = "Novo Livro"
        
        adjustLayout()
    }

    // MARK: IBActions
    
    @IBAction func coverFieldEditingDidEnd(_ sender: Any) {
        guard let coverPathAsString = coverPathTextField.text,
              !coverPathAsString.isEmpty else { return }
        
        guard let coverUri = URL(string: coverPathAsString) else { return }
        
        coverImageView.af.setImage(withURL: coverUri)
    }
}
