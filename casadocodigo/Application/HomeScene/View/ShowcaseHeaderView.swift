//
//  ShowcaseHeaderView.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import UIKit

class ShowcaseHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var sectionTitle: SectionTitle!
    
    func build() -> ShowcaseHeaderView {
        self.sectionTitle.label.text = "Todos os Livros"
        return self
    }
}
