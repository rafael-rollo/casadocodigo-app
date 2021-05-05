//
//  ShowcaseHeaderView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import UIKit

class ShowcaseHeaderView: UICollectionReusableView, ReusableView {
        
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    func build(delegate: SectionTitleDelegate) -> ShowcaseHeaderView {
        sectionTitle.delegate = delegate
        sectionTitle.label.text = "Todos os Livros"
        
        sectionTitle.enableItemAddingButton()
        return self
    }
}
