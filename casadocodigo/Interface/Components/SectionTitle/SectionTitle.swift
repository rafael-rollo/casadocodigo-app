//
//  SectionTitle.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit

class SectionTitle: UIView {

    // MARK: IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var label: UILabel!
    
    // for using the custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // for using the custom view in interface builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("SectionTitle", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
