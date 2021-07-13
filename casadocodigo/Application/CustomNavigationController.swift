//
//  CDCNavigationControllerViewController.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/05/21.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    private lazy var titleImageView: UIImageView = {
        let image = UIImage(named: "text-logo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleImageView)
        return view
    }()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        setup()
    }
}

extension CustomNavigationController: ViewCode {
    func addViews() {
        view.addSubview(titleView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.heightAnchor.constraint(equalToConstant: navigationBar.frame.size.height),
            titleView.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor,
                                             multiplier: 0.70)
        ])

        NSLayoutConstraint.activate([
            titleImageView.heightAnchor.constraint(equalTo: titleView.heightAnchor, multiplier: 0.8),
            titleImageView.widthAnchor.constraint(equalTo: titleView.heightAnchor),
            titleImageView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
        ])
    }
    
    func addTheme() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.orangeColor
        appearance.shadowColor = .none
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)]
        
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
}

extension UIViewController {
    func setupNavigationBar(itemsOnTheLeft: [NavigationBarItem] = [],
                            itemsOnTheRight: [NavigationBarItem] = []) {
        let parentOrSelf = parent is UITabBarController ? parent : self
        
        parentOrSelf?.navigationItem.setLeftBarButtonItems(
            itemsOnTheLeft.map { $0.toUIBarButtonItem() }, animated: true
        )
        
        parentOrSelf?.navigationItem.setRightBarButtonItems(
            itemsOnTheRight.map { $0.toUIBarButtonItem() }, animated: true
        )
    }
}
