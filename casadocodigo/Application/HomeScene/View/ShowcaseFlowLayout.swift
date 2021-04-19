//
//  ShowcaseFlowLayout.swift
//  casadocodigo
//
//  Created by rafael.rollo on 16/04/21.
//

import UIKit

fileprivate struct LayoutProperties {
    static let cellsPerLine: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
    static let horizontalSpacing: CGFloat = 16
    static let labelHeight: CGFloat = 70
}

class ShowcaseFlowLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    private func calculateCellHeightProportional(to cellWidth: CGFloat) -> CGFloat {
        let originalBookCoverProportion = CGSize(width: 336, height: 480)
        
        let proportionalHeight = originalBookCoverProportion.height * cellWidth / originalBookCoverProportion.width
        return proportionalHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
    
        let paddingsPerLine = LayoutProperties.cellsPerLine - 1
        let spacingOffset = LayoutProperties.horizontalSpacing * paddingsPerLine / LayoutProperties.cellsPerLine
        
        let adjustedCellWidth = collectionWidth / LayoutProperties.cellsPerLine - spacingOffset
        let adjustedCellHeight = self.calculateCellHeightProportional(to: adjustedCellWidth) + LayoutProperties.labelHeight
        
        return CGSize(width: adjustedCellWidth, height: adjustedCellHeight)
    }
}
