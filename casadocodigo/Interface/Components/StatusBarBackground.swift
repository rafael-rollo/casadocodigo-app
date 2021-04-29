//
//  StatusBarBackground.swift
//  casadocodigo
//
//  Created by rafael.rollo on 09/04/21.
//

import UIKit

class StatusBarBackground: NSObject {

    let targetView: UIView
    
    var statusBarHeight: CGFloat {
        return targetView.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
    }

    init(target: UIView) {
        self.targetView = target
    }
    
    func set(color: UIColor) {
        if #available(iOS 13.0, *) {
            let statusbarView = UIView()
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.backgroundColor = color
            
            targetView.addSubview(statusbarView)
          
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: targetView.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: targetView.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: targetView.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
}
