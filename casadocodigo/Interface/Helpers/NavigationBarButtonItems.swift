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
    case image(UIImage)
    case button(UIImage, Any?, Selector?)
    case barSystemItem(UIBarButtonItem.SystemItem, Any?, Selector?)
    case custom(UIBarButtonItem)
    
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
            let defaultSize: CGFloat = 40
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: defaultSize),
                imageView.heightAnchor.constraint(equalToConstant: defaultSize)
            ])
            
            return UIBarButtonItem(customView: imageView)
        
        case let .button(icon , target, selector):
            let button = UIBarButtonItem(image: icon,
                                         style: .plain,
                                         target: target,
                                         action: selector)
            button.tintColor = .white
            return button
        
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
