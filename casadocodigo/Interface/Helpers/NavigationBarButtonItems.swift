//
//  NavigationButtonItems.swift
//  casadocodigo
//
//  Created by rafael.rollo on 14/06/21.
//

import UIKit

enum NavigationBarItem {
    case space(CGFloat)
    case label(String)
    case image(UIImage?)
    case button(String, Any?, Selector?)
    case barSystemItem(UIBarButtonItem.SystemItem, Any?, Selector?)
    case custom(UIBarButtonItem)
    
    static let defaultSize: CGFloat = 24
    
    func toUIBarButtonItem() -> UIBarButtonItem {
        switch self {
        case let .space(width):
            let itemSpacing = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                              target: nil,
                                              action: nil)
            itemSpacing.width = width
            return itemSpacing
        
        case let .label(text):
            let label = UILabel()
            label.text = text
            label.textColor = .black
            label.sizeToFit()
            return UIBarButtonItem(customView: label)
            
        case let .image(image):
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: NavigationBarItem.defaultSize),
                imageView.heightAnchor.constraint(equalToConstant: NavigationBarItem.defaultSize)
            ])
            
            return UIBarButtonItem(customView: imageView)
        
        case let .button(icon, target, selector):
            let image = UIImage(named: icon)?.withTintColor(.white)
            
            let button = UIButton(type: .custom)
            button.setImage(image, for: .normal)
            
            if let target = target, let selector = selector {
                button.addTarget(target, action: selector, for: .touchUpInside)
            }
            
            let barButtonItem = UIBarButtonItem(customView: button)
            NSLayoutConstraint.activate([
                barButtonItem.customView!.widthAnchor.constraint(equalToConstant: NavigationBarItem.defaultSize),
                barButtonItem.customView!.heightAnchor.constraint(equalToConstant: NavigationBarItem.defaultSize)
            ])
            
            return barButtonItem
        
        case let .barSystemItem(item, target, selector):
            let button = UIBarButtonItem(barButtonSystemItem: item,
                            target: target,
                            action: selector)
            button.tintColor = .white
            return button
        
        case let .custom(item):
            return item
        }
    }
}
