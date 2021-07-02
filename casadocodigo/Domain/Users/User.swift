//
//  User.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import Foundation

class Authentication: Codable {
    private var tokenType: String
    private var token: String
    
    var value: String {
        return "\(tokenType) \(token)"
    }
    
    init(tokenType: String = "Bearer", token: String) {
        self.tokenType = tokenType
        self.token = token
    }
    
    enum CodingKeys: String, CodingKey {
        case tokenType
        case token
    }
}

enum Role: String, Codable {
    case CLIENT
    case ADMIN
}

class User: Codable {
    private(set) var name: String
    private(set) var role: Role
    private(set) var authentication: Authentication
    
    var email: String?
    
    init(name: String, role: Role, authentication: Authentication) {
        self.name = name
        self.role = role
        self.authentication = authentication
    }
}
