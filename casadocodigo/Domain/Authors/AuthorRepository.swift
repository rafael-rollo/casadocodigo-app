//
//  AuthorRepository.swift
//  casadocodigo
//
//  Created by rafael.rollo on 19/04/21.
//

import UIKit
import Alamofire

class AuthorRepository: NSObject {
    
    static let authorsBasePath = "https://casadocodigo-api.herokuapp.com/api/author"

    func allAuthors(completionHandler: @escaping ([Author]) -> Void, failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(AuthorRepository.authorsBasePath, headers: headers)
            .validate()
            .responseDecodable(of: [Author].self) { response in
                switch response.result {
                case .success:
                    guard let authors = response.value else { return }
                    completionHandler(authors)
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
            
    }
}
