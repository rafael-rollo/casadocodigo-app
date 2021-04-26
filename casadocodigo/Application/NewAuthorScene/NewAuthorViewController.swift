//
//  NewAuthorViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 23/04/21.
//

import UIKit
import AlamofireImage

class NewAuthorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var sectionTitle: SectionTitle!
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var pictureUrlTextField: UITextField!
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
        
        self.profilePictureView.roundTheShape()
        
        self.bioTextView.layer.cornerRadius = 6
        self.bioTextView.layer.borderWidth = 0.2
        self.bioTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.addAuthorButton.layer.cornerRadius = 10
        self.addAuthorButton.showsTouchWhenHighlighted = true
    }
    
    @IBAction func pictureFieldEditingDidEnd(_ sender: UITextField) {
        guard let pictureURLAsString = self.pictureUrlTextField.text,
              !pictureURLAsString.isEmpty else { return }
        
        guard let pictureURL = URL(string: pictureURLAsString) else { return }
        
        self.profilePictureView.af.setImage(withURL: pictureURL)
        self.profilePictureView.roundTheShape()
    }
}
