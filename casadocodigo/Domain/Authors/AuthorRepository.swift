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

    func allAuthors(completionHandler: @escaping ([AuthorResponse]) -> Void, failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        
        AF.request(AuthorRepository.authorsBasePath, headers: headers)
            .validate()
            .responseDecodable(of: [AuthorResponse].self) { response in
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
    
    func saveNew(author: AuthorRequest, completionHandler: @escaping (AuthorResponse) -> Void, failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "application/json", "Accept": "application/json"]
                
        AF.request(AuthorRepository.authorsBasePath, method: .post, parameters: author, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: AuthorResponse.self) { response in
                switch response.result {
                case .success:
                    guard let createdAuthor = response.value else { return }
                    completionHandler(createdAuthor)
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
    
    func deleteAuthor(identifiedBy id: Int, completionHandler: @escaping () -> Void, failureHandler: @escaping () -> Void) {
        let resourceURI = "\(AuthorRepository.authorsBasePath)/\(id)"
        
        AF.request(resourceURI, method: .delete)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completionHandler()
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
    
    func update(_ author: AuthorRequest, identifiedBy authorId: Int,
                      completionHandler: @escaping (AuthorResponse) -> Void, failureHandler: @escaping () -> Void) {
        let resourceURI = "\(AuthorRepository.authorsBasePath)/\(authorId)"
        let headers: HTTPHeaders = ["Content-type": "application/json", "Accept": "application/json"]
        
        AF.request(resourceURI, method: .put, parameters: author, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: AuthorResponse.self) { response in
                switch response.result {
                case .success:
                    guard let updatedAuthor = response.value else { return }
                    completionHandler(updatedAuthor)
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
}
