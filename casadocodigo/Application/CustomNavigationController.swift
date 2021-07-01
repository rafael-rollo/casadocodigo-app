//
//  CDCNavigationControllerViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/05/21.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    var titleView: UIView!
    
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
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.orangeColor
        appearance.shadowColor = .none
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
        titleView = UIView(frame: CGRect.zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleView)
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.heightAnchor.constraint(equalToConstant: navigationBar.frame.size.height),
            titleView.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor,
                                             multiplier: 0.70)
        ])
        
        let title = UIImage(named: "text-logo")
        let titleImageView = UIImageView(image: title)
        titleImageView.contentMode = .scaleAspectFill
        titleImageView.translatesAutoresizingMaskIntoConstraints = false

        titleView.addSubview(titleImageView)
        NSLayoutConstraint.activate([
            titleImageView.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.8),
            titleImageView.widthAnchor.constraint(equalTo: titleView.heightAnchor),
            titleImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
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
