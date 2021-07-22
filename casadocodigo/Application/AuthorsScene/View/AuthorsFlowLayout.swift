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
    
    private var horizontalMargin: CGFloat {
        return renderingOnPhone ? 16 : 32
    }
    
    private var headerHeight: CGFloat {
        return renderingOnPhone ? 50 : 64
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
        minimumInteritemSpacing = renderingOnPhone ? 16 : 32
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
        let spacingToDiscount = horizontalMargin * 2 + minimumInteritemSpacing * internalPaddings
        
        let adjustedWidth = (collectionView.bounds.width - spacingToDiscount) / cellsPerLine
        return CGSize(width: adjustedWidth, height: 206)
    }
    
    func sizeForHeaderOf(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         atSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: headerHeight)
    }
}
