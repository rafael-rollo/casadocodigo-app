//
//  File.swift
//  casadocodigo
//
//  Created by rafael.rollo on 04/06/21.
//

import UIKit

extension UIView {
    func setVisibleOnly(to authorizedRoles: Role...) {
        // hide when anonymous
        guard let authenticatedUser = UserDefaults.standard.getAuthenticated() else {
            isHidden = true
            return
        }
        
        let isAuthorizedUser = authorizedRoles.reduce(false) {
            $1 == authenticatedUser.role || $0
        }
        
        isHidden = !isAuthorizedUser
    }
    
    func setHidden(for unauthorizedRoles: Role...) {
        guard let authenticatedUser = UserDefaults.standard.getAuthenticated() else {
            isHidden = false
            return
        }
        
        let isUnauthorizedUser = unauthorizedRoles.reduce(false) {
            $1 == authenticatedUser.role || $0
        }
        
        isHidden = isUnauthorizedUser
    }
}