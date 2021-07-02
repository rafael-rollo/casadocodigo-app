//
//  SearchFooter.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/07/21.
//

import UIKit

class SearchFooter: UIView {
    let label = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.orangeColor
        alpha = 0.0
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
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
