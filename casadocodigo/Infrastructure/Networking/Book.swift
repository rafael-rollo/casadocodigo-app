//
//  BookShowcaseItem.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import Foundation

enum BookType: String, Codable {
    case ebook = "EBOOK"
    case hardCover = "HARDCOVER"
    case combo = "COMBO"
}

struct BookResponse: Decodable {
    let id: Int
    let title: String
    let subtitle: String
    let coverImagePath: URL
    let prices: [Price]
    let description: String
    let author: AuthorResponse
    let numberOfPages: Int
    let ISBN: String
    let publicationDate: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case coverImagePath
        case prices
        case description
        case author
        case numberOfPages
        case ISBN = "isbn"
        case publicationDate
    }
    
    struct Price: Decodable {
        let value: Decimal
        let bookType: BookType
        
        init(value: Double, bookType: BookType) {
            let decimalValue: Decimal = NSNumber(floatLiteral: value).decimalValue
        
            self.value = decimalValue
            self.bookType = bookType
        }
        
        enum CodingKeys: String, CodingKey {
            case value
            case bookType
        }
    }
}

struct BookRequest: Encodable {
    let title: String
    let subtitle: String
    let coverImagePath: String
    
    let eBookPrice: Decimal
    let hardcoverPrice: Decimal
    let comboPrice: Decimal
    
    let description: String
    let authorId: Int
    let publicationDate: String
    let numberOfPages: Int
    let ISBN: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case coverImagePath
        case eBookPrice
        case hardcoverPrice
        case comboPrice
        case description
        case authorId
        case publicationDate
        case numberOfPages
        case ISBN = "isbn"
    }
}
