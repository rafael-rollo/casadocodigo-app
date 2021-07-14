//
//  SectionTitle.swift
//  casadocodigo
//
//  Created by rafael.rollo on 20/04/21.
//

import UIKit

@IBDesignable class SectionTitle: UIView {
    
    private var titleHeight: CGFloat {
        return renderingOnPhone ? 32 : 44
    }
    
    private var fontSize: CGFloat {
        return renderingOnPhone ? 24 : 32
    }
    
    private var borderHeight: CGFloat {
        return renderingOnPhone ? 0.5 : 1.5
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: fontSize)
        label.textColor = UIColor(named: "strongOrange")
        label.text = "Section Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var borderBottom: UIView = {
        let border = UIView()
        border.backgroundColor = UIColor(named: "strongOrange")
        border.translatesAutoresizingMaskIntoConstraints = false
        return border
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func setText(_ text: String) {
        titleLabel.text = text
    }
    
    func useTextColor() {
        titleLabel.textColor = .secondaryLabel
        borderBottom.backgroundColor = .secondaryLabel
    }
}

extension SectionTitle: ViewCode {
    func addViews() {
        addSubview(borderBottom)
        addSubview(titleLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            borderBottom.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderBottom.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderBottom.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderBottom.heightAnchor.constraint(equalToConstant: borderHeight)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: borderBottom.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: titleHeight)
        ])
    }
    
    func addTheme() {
        backgroundColor = .clear
    }
}
