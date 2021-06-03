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
    
    func get() -> User? {
        guard let authenticatedUserData = UserDefaults.standard
                .object(forKey: UserAuthenticationRepository.key) as? Data else { return nil }
        let decoder = PropertyListDecoder()
        guard let authenticatedUser = try? decoder
                .decode(User.self, from: authenticatedUserData) else { return nil }
        return authenticatedUser
    }
}
