//
//  BookRepository.swift
//  casadocodigo
//
//  Created by rafael.rollo on 14/04/21.
//

import UIKit
import Alamofire

class BookRepository: NSObject {

    static let bookBasePath = "https://casadocodigo-api.herokuapp.com/api/boor"
    
    func showcase(completionHandler: @escaping ([BookShowcaseItem]) -> Void, failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(BookRepository.bookBasePath, headers: headers)
            .validate()
            .responseDecodable(of: [BookShowcaseItem].self) { response in
                switch response.result {
                case .success:
                    guard let bookShowcase = response.value else { return }
                    completionHandler(bookShowcase)
                
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
}
