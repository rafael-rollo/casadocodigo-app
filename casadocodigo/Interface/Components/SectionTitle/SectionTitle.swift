//
//  SectionTitle.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit

fileprivate struct LayoutProperties {
    static let textColor: UIColor = UIColor(red: 108/255, green: 105/255, blue: 105/255, alpha: 0.8)
}

protocol SectionTitleDelegate: class {
    func didAddButtonPressed(_ sender: UIButton)
}

class SectionTitle: UIView, IdentifiableView {

    // MARK: Attributes
    
    weak var delegate: SectionTitleDelegate?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var itemAddingButton: UIButton!
    @IBOutlet weak var bottomDivider: UIView!
    
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
        guard delegate != nil else {
            fatalError("Required delegate attribute not fulfilled")
        }
        
        let buttonImage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        itemAddingButton.setImage(buttonImage, for: .normal)
        itemAddingButton.isHidden = false
        itemAddingButton.addTarget(self, action: #selector(addItemButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func addItemButtonPressed(_ sender: UIButton!) {
        delegate?.didAddButtonPressed(sender)
    }
    
    func useTextColor() {
        label.textColor = LayoutProperties.textColor
        bottomDivider.backgroundColor = LayoutProperties.textColor
    }
}
