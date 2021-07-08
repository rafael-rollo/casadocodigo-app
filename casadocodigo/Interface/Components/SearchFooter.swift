//
//  SearchFooter.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/07/21.
//

import UIKit

class SearchFooter: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
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
    
    override func draw(_ rect: CGRect) {
        label.frame = bounds
    }
  
    func setNotFiltering() {
        label.text = ""
        hide()
    }
  
    func setIsFiltering(_ filteredItemCount: Int, of totalItemCount: Int) {
        guard filteredItemCount < totalItemCount else {
            setNotFiltering()
            return
        }
        
        let filteringMessage = filteredItemCount == 0
            ? "Sua busca não gerou resultados"
            : "Exibindo \(filteredItemCount) de \(totalItemCount) livros"
        
        label.text = filteringMessage
        show()
    }
  
    func hide() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 0.0
        }
    }
  
    func show() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 0.92
        }
    }
}

extension SearchFooter: ViewCode {
    func addViews() {
        addSubview(label)
    }

    func addTheme() {
        backgroundColor = UIColor.orangeColor
        alpha = 0.0
    }
}
