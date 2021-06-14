//
//  CDCNavigationControllerViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/05/21.
//

import UIKit

class CDCNavigationController: UINavigationController {

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigation()
    }
    
    fileprivate func setupNavigation() {
        UIBarButtonItem.appearance().tintColor = UIColor.white
   
        navigationBar.barTintColor = UIColor.orangeColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.shadowImage = UIImage()
        
        let titleView = UIView(frame: CGRect.zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        ])
        
        let logo = UIImage(named: "logo-cdc")
        let titleImageView = UIImageView(image: logo)
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        titleView.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.heightAnchor.constraint(equalTo: titleView.heightAnchor),
            titleImageView.widthAnchor.constraint(equalTo: titleView.heightAnchor),
            titleImageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
    
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Casa do Código"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: "Helvetica Neue", size: 22)

        titleView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor, constant: Theme.spacing.xsmall),
            titleLabel.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor, constant: -2)
        ])
        
    }
}
