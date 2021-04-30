//
//  SectionTitle.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit

protocol SectionTitleDelegate: class {
    func didAddButtonPressed(_ sender: UIButton)
}

class SectionTitle: UIView, IdentifiableView {

    // MARK: Attributes
    
    weak var delegate: SectionTitleDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var itemAddingButton: UIButton!
    
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
        Bundle.main.loadNibNamed(SectionTitle.nibName, owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth]
        addSubview(contentView)
    }
    
    func enableItemAddingButton() {
        guard self.delegate != nil else {
            fatalError("Required delegate attribute not fulfilled")
        }
        
        let buttonImage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        self.itemAddingButton.setImage(buttonImage, for: .normal)
    
        self.itemAddingButton.isHidden = false
        self.itemAddingButton.addTarget(self, action: #selector(addItemButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func addItemButtonPressed(_ sender: UIButton!) {
        self.delegate?.didAddButtonPressed(sender)
    }
}
