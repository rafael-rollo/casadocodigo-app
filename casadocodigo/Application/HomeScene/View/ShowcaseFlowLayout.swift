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
    
    private var cellsPerLine: CGFloat {
        return renderingOnPhone ? 2 : 3
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
    
    private func calculateItemHeightProportional(to width: CGFloat) -> CGFloat {
        let originalBookCoverProportion = CGSize(width: 336, height: 474)
        
        let coverProportionalHeight = (width * originalBookCoverProportion.height) / originalBookCoverProportion.width
        return coverProportionalHeight + labelWrapperHeight
    }
    
    func sizeForItemOf(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       atIndex indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
    
        let paddings = cellsPerLine - 1
        let totalPaddingOffset = minimumInteritemSpacing * paddings
        
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
