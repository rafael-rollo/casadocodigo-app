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

class User {
    private(set) var email: String
    private var authentication: Authentication?
    
    init(email: String) {
        self.email = email
    }
    
    func setAuthentication(authentication: Authentication) {
        self.authentication = authentication
    }
    
    func getAuthentication() -> String? {
        return authentication?.value
    }
}
