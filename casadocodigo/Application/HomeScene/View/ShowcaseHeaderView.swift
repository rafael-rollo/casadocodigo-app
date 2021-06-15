//
//  ShowcaseHeaderView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import UIKit

class ShowcaseHeaderView: UICollectionReusableView, ReusableView {
        
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    func build(delegate: SectionTitleDelegate? = nil) -> ShowcaseHeaderView {
        if let delegate = delegate {
            sectionTitle.delegate = delegate
            sectionTitle.enableItemAddingButton()
        }
        
        sectionTitle.label.text = "Todos os Livros"
        return self
    }
}
