//
//  TagCell.swift
//  casadocodigo
//
//  Created by rafael.rollo on 21/04/21.
//

import UIKit

fileprivate struct tagFont {
    static let name: String = "HelveticaNeue-Medium"
    static let size: CGFloat = 14
}

class TagCell: UICollectionViewCell, ReusableView, IdentifiableView {
    
    private lazy var taglabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: tagFont.name, size: tagFont.size)
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
    
    func getMinSizeForCell(with label: String, in parent: UIView) -> CGSize? {
        guard let cellFont = UIFont(name: tagFont.name, size: tagFont.size) else { return nil }
        let fontAttributes = [NSAttributedString.Key.font: cellFont]
        
        let size = (label as NSString).size(withAttributes: fontAttributes)
        let adjustedSize = size.width + Theme.spacing.small * 2
        
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
        contentView.layer.cornerRadius = 16
    }
}
