//
//  TagCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

class TagCell: UICollectionViewCell, ReusableView, IdentifiableView {
    
    private let fontName: String = "HelveticaNeue-Medium"
    
    private var fontSize: CGFloat {
        return renderingOnPhone ? 14 : 18
    }
    
    private var horizontalPadding: CGFloat {
        return renderingOnPhone ? Theme.spacing.small : Theme.spacing.medium
    }
    
    private var radius: CGFloat {
        return renderingOnPhone ? 16 : 20
    }
    
    private lazy var taglabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func set(label: String) {
        taglabel.text = label
    }
    
    func getMinSizeForCell(for label: String, in parent: UIView) -> CGSize? {
        guard let cellFont = UIFont(name: fontName, size: fontSize) else { return nil }
        let fontAttributes = [NSAttributedString.Key.font: cellFont]
        
        let size = (label as NSString).size(withAttributes: fontAttributes)
        let adjustedSize = size.width + horizontalPadding * 2
        
        return CGSize(width: adjustedSize, height: parent.bounds.height)
    }
}

extension TagCell: ViewCode {
    func addViews() {
        contentView.addSubview(taglabel)
    }
    
    func addConstraints() {
        taglabel.constrainTo(boundsOf: contentView)
    }
    
    func addTheme() {
        contentView.backgroundColor = UIColor(named: "brandYellow")
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = radius
    }
}
