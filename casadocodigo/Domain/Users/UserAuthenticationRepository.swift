//
//  UsersRepository.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import UIKit

extension UserDefaults {
    
    private static let authenticationKey = "UserAuthentication"
    
    func setAuthenticated(_ authenticatedUser: User) {
        let encoder = PropertyListEncoder()
        if let encoded = try? encoder.encode(authenticatedUser) {
            set(encoded, forKey: UserDefaults.authenticationKey)
        }
    }
    
    func getAuthenticated() -> User? {
        guard let authenticatedUserData = object(forKey: UserDefaults.authenticationKey)
                as? Data else { return nil }
        
        let decoder = PropertyListDecoder()
        guard let authenticatedUser = try? decoder
                .decode(User.self, from: authenticatedUserData) else { return nil }
        
        return authenticatedUser
    }
    
    func hasAuthenticatedUser() -> Bool {
        if getAuthenticated() == nil {
            return false
        }
        return true
    }
}
