//
//  User.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import Foundation

struct AuthenticationRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
