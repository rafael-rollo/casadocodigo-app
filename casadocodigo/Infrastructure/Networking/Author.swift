//
//  Author.swift
//  casadocodigo
//
//  Created by rafael.rollo on 19/04/21.
//

import Foundation

class AuthorRequest: Encodable {
    let firstName: String
    let lastName: String
    let bio: String
    let profilePicturePath: String
    var technologies: [String] = []
    
    init(fullName: String, bio: String, profilePicturePath: String, technologies: String? = nil) {
        let names = fullName.components(separatedBy: " ")
        
        self.firstName = names[0]
        self.lastName = names[names.count - 1]
        self.bio = bio
        self.profilePicturePath = profilePicturePath
        
        if let technologies = technologies, !technologies.isEmpty {
            self.technologies = technologies.components(separatedBy: "; ")
        }
    }
        
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case bio
        case profilePicturePath
        case technologies
    }
    
    class Editing: AuthorRequest {
        let id: Int
        
        init(id: Int, fullName: String, bio: String, profilePicturePath: String, technologies: String? = nil) {
            self.id = id
            super.init(fullName: fullName, bio: bio, profilePicturePath: profilePicturePath, technologies: technologies)
        }
        
        enum CodingKeys: String, CodingKey {
            case id
        }
    }
}

struct AuthorResponse: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let bio: String
    let profilePicturePath: URL
    let technologies: [String]
    let publishedBooks: Int
    
    var fullName: String {
        return "\(firstName) \(lastName)"
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
