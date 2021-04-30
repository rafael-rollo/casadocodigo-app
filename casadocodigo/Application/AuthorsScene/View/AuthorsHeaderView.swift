//
//  AuthorsHeaderView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit

class AuthorsHeaderView: UICollectionReusableView, ReusableView {
        
    // MARK: IBOutlets
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    func build(delegate: SectionTitleDelegate) -> AuthorsHeaderView {
        sectionTitle.delegate = delegate
        sectionTitle.label.text = "Nossos Autores"
        
        sectionTitle.enableItemAddingButton()
        return self
    }
}
