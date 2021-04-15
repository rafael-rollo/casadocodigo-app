//
//  BookShowcaseItem.swift
//  casadocodigo
//
//  Created by rafael.rollo on 15/04/21.
//

import Foundation

struct BookShowcaseItem: Decodable {
    let id: Int
    let coverImagePath: URL
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case coverImagePath
        case title
    }
}
