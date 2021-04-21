//
//  Author.swift
//  casadocodigo
//
//  Created by rafael.rollo on 19/04/21.
//

import Foundation

struct Author: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let bio: String
    let profilePicturePath: URL
    let technologies: [String]
    let publishedBooks: Int
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case bio
        case profilePicturePath
        case technologies = "technologiesSHeWritesAbout"
        case publishedBooks
    }
}
