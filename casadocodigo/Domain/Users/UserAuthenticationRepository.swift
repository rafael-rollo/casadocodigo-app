//
//  UsersRepository.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import UIKit

class UserAuthenticationRepository: NSObject {
    
    private static let key = "UserAuthentication"
    
    func save(_ authenticatedUser: User) {
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(authenticatedUser) {
            UserDefaults.standard.set(encoded, forKey: UserAuthenticationRepository.key)
        }
    }
}
