//
//  NavigationBar.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class NavigationBar: UIView, IdentifiableView {
    
    static let COLOR = UIColor(
        red: 255/255,
        green: 170/255,
        blue: 86/255,
        alpha: 0.8
    )
    
    // MARK: IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
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
        Bundle.main.loadNibNamed(NavigationBar.nibName, owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        logoImageView.image = UIImage(named: "logo-cdc")
    }
}
