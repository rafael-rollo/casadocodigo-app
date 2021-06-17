//
//  CDCNavigationControllerViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/05/21.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNavigation()
    }
    
    fileprivate func setupNavigation() {
        navigationBar.barTintColor = UIColor.orangeColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.shadowImage = UIImage()
        
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        let titleView = UIView(frame: CGRect.zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75)
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

extension UIViewController {
    func setupNavigationBar(itemsOnTheLeft: [NavigationBarItem] = [],
                            itemsOnTheRight: [NavigationBarItem] = []) {
        let parentOrSelf = parent is UITabBarController ? parent : self
        parentOrSelf?.navigationItem.setLeftBarButtonItems(itemsOnTheLeft.map { $0.toUIBarButtonItem() },
                                                           animated: true)
        parentOrSelf?.navigationItem.setRightBarButtonItems(itemsOnTheRight.map { $0.toUIBarButtonItem() },
                                                            animated: true)
    }
}
