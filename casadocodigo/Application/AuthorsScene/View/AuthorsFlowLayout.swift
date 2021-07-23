//
//  AuthorsFlowLayout.swift
//  casadocodigo
//
//  Created by rafael.rollo on 22/07/21.
//

import UIKit

class AuthorsFlowLayout: UICollectionViewFlowLayout {
    
    private var renderingOnPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    private var defaultSpacing: CGFloat {
        return renderingOnPhone ? 16 : 24
    }
    
    private var headerHeight: CGFloat {
        return renderingOnPhone ? 50 : 64
    }
    
    private var itemHeight: CGFloat {
        return renderingOnPhone ? 232 : 306
    }
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        minimumInteritemSpacing = defaultSpacing
    }
    
    fileprivate func calculateCellsPerLine(by traits: UITraitCollection) -> CGFloat {
        switch (traits.verticalSizeClass, traits.horizontalSizeClass) {
        case (_, .regular):
            return 2
        default:
            return 1
        }
    }
    
    func sizeForItemOf(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       atIndex indexPath: IndexPath) -> CGSize {
        let cellsPerLine = calculateCellsPerLine(by: collectionView.traitCollection)
        let internalPaddings = cellsPerLine - 1
        let spacingToDiscount = minimumInteritemSpacing * internalPaddings
        
        let adjustedWidth = (collectionView.bounds.width - spacingToDiscount) / cellsPerLine
        return CGSize(width: adjustedWidth, height: itemHeight)
    }
    
    func sizeForHeaderOf(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         atSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: headerHeight)
    }
}
