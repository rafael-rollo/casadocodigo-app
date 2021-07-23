//
//  ShowcaseFlowLayout.swift
//  casadocodigo
//
//  Created by rafael.rollo on 16/04/21.
//

import UIKit

class ShowcaseFlowLayout: UICollectionViewFlowLayout {
    
    private var renderingOnPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    private var labelWrapperHeight: CGFloat {
        return 90
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
    
    private func calculateCells(by traitCollection: UITraitCollection) -> CGFloat {
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
        case (.compact, _):
            return 4
                        
        case (.regular, .regular):
            return 3
        
        case (.regular, .compact):
            return 2
        
        default:
            fatalError("Could not be possible to calculate the cells number per line")
        }
    }
    
    private func calculateItemHeightProportional(to width: CGFloat) -> CGFloat {
        let originalBookCoverProportion = CGSize(width: 336, height: 474)
        
        let coverProportionalHeight = (width * originalBookCoverProportion.height) / originalBookCoverProportion.width
        return coverProportionalHeight + labelWrapperHeight
    }
    
    func sizeForItemOf(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       atIndex indexPath: IndexPath) -> CGSize {
        let cellsPerLine = calculateCells(by: collectionView.traitCollection)
    
        let paddings = cellsPerLine - 1
        let totalPaddingOffset = minimumInteritemSpacing * paddings
        
        let collectionWidth = collectionView.bounds.width
        let itemWidth = (collectionWidth - totalPaddingOffset) / cellsPerLine
        let itemHeight = self.calculateItemHeightProportional(to: itemWidth)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func sizeForHeaderOf(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         atSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: headerHeight)
    }
}
