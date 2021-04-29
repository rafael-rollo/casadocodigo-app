//
//  CollectionViewCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
