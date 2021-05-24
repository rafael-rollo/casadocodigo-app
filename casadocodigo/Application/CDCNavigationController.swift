//
//  CDCNavigationControllerViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/05/21.
//

import UIKit

class CDCNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigation()
    }
    
    fileprivate func setupNavigation() {
        navigationBar.barTintColor = UIColor.orangeColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        let titleView = UIView(frame: CGRect.zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        let logo = UIImage(named: "logo-cdc")
        let titleImageView = UIImageView(image: logo)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(titleImageView)
        titleImageView.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        titleImageView.widthAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        titleImageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        titleImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Casa do Código"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 22)
        
        titleView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: Theme.spacing.xsmall).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor, constant: -2).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
