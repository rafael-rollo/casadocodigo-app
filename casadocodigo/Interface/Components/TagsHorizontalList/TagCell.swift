//
//  TagCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

class TagCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet var cellContentView: UIView!
    @IBOutlet weak var tagLabel: UILabel!
    
    // for using the custom view in code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // for using the custom view in interface builder
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("TagCell", owner: self, options: nil)
    
        cellContentView.frame = self.bounds
        cellContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(cellContentView)
    }
    
    func setFrom(_ label: String) {
        tagLabel.text = label
        
        configureBorders()
    }
    
    private func configureBorders() {
        cellContentView.layer.masksToBounds = false
        cellContentView.layer.cornerRadius = 10
    }
}

extension TagCell {
    
    private static let fontName: String = "HelveticaNeue-Medium"
    private static let fontSize: CGFloat = 14
    private static let labelHorizontalPadding: CGFloat = 12
    
    func getMinSizeForCell(with label: String, in parent: UIView) -> CGSize? {
        guard let cellFont = UIFont(name: TagCell.fontName, size: TagCell.fontSize) else { return nil }
        let fontAttributes = [NSAttributedString.Key.font: cellFont]
        
        let size = (label as NSString).size(withAttributes: fontAttributes)
        let adjustedSize = size.width + TagCell.labelHorizontalPadding * 2
        
        return CGSize(width: adjustedSize, height: parent.bounds.height)
    }
}
