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
        UIBarButtonItem.appearance().tintColor = UIColor.white
        // global hide back button string - hack =/
//        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    
        navigationBar.barTintColor = UIColor.orangeColor
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.shadowImage = UIImage()
        
        let titleView = UIView(frame: CGRect.zero)
        titleView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleView)
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        titleView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
//        titleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true

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
        titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleImageView.centerYAnchor, constant: -2).isActive = true
    }

}

enum NavigationBarItemType {
    case space(CGFloat)
    case image(UIImage)
    case label(String)
    case barSystemItem(UIBarButtonItem.SystemItem, Any?, Selector?)
    case button(UIImage, Any?, Selector?)
    case custom(UIBarButtonItem)

    func toUIBarItem() -> UIBarButtonItem {
        switch self {
        case let .space(width):
            let itemSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                              target: nil,
                                              action: nil)
            itemSpacing.width = width
            return itemSpacing
        case let .image(image):
            let defaultSize: CGFloat = 40
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: defaultSize),
                imageView.heightAnchor.constraint(equalToConstant: defaultSize)
            ])
            return UIBarButtonItem(customView: imageView)
        case let .label(text):
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.sizeToFit()
            return UIBarButtonItem(customView: label)
        case let .barSystemItem(item, target, selector):
            let button = UIBarButtonItem(
                barButtonSystemItem: item,
                target: target,
                action: selector
            )
            button.tintColor = .white
            return button
        case let .button(icon, target, selector):
            let button = UIBarButtonItem(
                image: icon,
                style: .plain,
                target: target,
                action: selector
            )
            button.tintColor = .white
            return button
        case let .custom(item):
           return item
        }
    }
}

extension UIViewController {
    func setupNavigationBar(leftItems: [NavigationBarItemType] = [],
                            rightItems: [NavigationBarItemType] = []) {
        if parent is UITabBarController {
            parent?.navigationItem.setLeftBarButtonItems(leftItems.map { $0.toUIBarItem() }, animated: true)
            parent?.navigationItem.setRightBarButtonItems(rightItems.map { $0.toUIBarItem() }, animated: true)
        } else {
            navigationItem.setLeftBarButtonItems(leftItems.map { $0.toUIBarItem() }, animated: true)
            navigationItem.setRightBarButtonItems(rightItems.map { $0.toUIBarItem() }, animated: true)
        }
    }
}
