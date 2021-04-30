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
    
    // MARK: Attributes
    
    private var navigator: UINavigationController?
    
    // MARK: IBOutlets
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
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
    
    func configure(_ navigationController: UINavigationController?, current: UIViewController) {
        guard let navigationController = navigationController else { return }
        
        guard navigationController.topViewController == current,
              navigationController.viewControllers.count > 1 else { return }
        
        self.navigator = navigationController
        
        let buttonImage = UIImage(named: "back-arrow")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(buttonImage, for: .normal)
        backButton.isHidden = false
        backButton.addTarget(self, action: #selector(backToPreviousScene), for: .touchUpInside)
    }
    
    @objc func backToPreviousScene() {
        navigator?.popViewController(animated: true)
    }
}
