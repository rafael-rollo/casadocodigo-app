//
//  BookRepository.swift
//  casadocodigo
//
//  Created by rafael.rollo on 14/04/21.
//

import UIKit
import Alamofire

class BookRepository: NSObject {

    static let bookBasePath = "https://casadocodigo-api.herokuapp.com/api/book"
    
    var defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func showcase(completionHandler: @escaping ([BookResponse]) -> Void, failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(BookRepository.bookBasePath, headers: headers)
            .validate()
            .responseDecodable(of: [BookResponse].self) { response in
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
    
    func saveNew(_ book: BookRequest, completionHandler: @escaping (BookResponse) -> Void,
                 failureHandler: @escaping () -> Void) {
        guard let authenticatedUser = defaults.getAuthenticated() else {
            debugPrint("An authenticated user is required to process the request for \(#function)")
            failureHandler()
            
            return
        }
        
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": authenticatedUser.authentication.value
        ]
        
        AF.request(BookRepository.bookBasePath, method: .post, parameters: book, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookResponse.self) { response in
                switch response.result {
                case .success:
                    guard let createdBook = response.value else { return }
                    completionHandler(createdBook)
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
    
    func deleteBook(identifiedBy id: Int, completionHandler: @escaping () -> Void, failureHandler: @escaping () -> Void) {
        guard let authenticatedUser = defaults.getAuthenticated() else {
            debugPrint("An authenticated user is required to process the request for \(#function)")
            failureHandler()
            
            return
        }
       
        let headers: HTTPHeaders = ["Authorization": authenticatedUser.authentication.value]
        let resourceURI = "\(BookRepository.bookBasePath)/\(id)"
        
        AF.request(resourceURI, method: .delete, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    completionHandler();
                
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
    
    func update(_ book: BookRequest, identifiedBy bookId: Int, completionHandler: @escaping (BookResponse) -> Void, failureHandler: @escaping () -> Void) {
        guard let authenticatedUser = defaults.getAuthenticated() else {
            debugPrint("An authenticated user is required to process the request for \(#function)")
            failureHandler()
            
            return
        }
        
        let headers: HTTPHeaders = ["Content-type": "application/json",
                                    "Accept": "application/json",
                                    "Authorization": authenticatedUser.authentication.value]
        let resourceURI = "\(BookRepository.bookBasePath)/\(bookId)"
     
        AF.request(resourceURI, method: .put, parameters: book, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BookResponse.self) { response in
                switch response.result {
                case .success:
                    guard let updatedBook = response.value else { return }
                    completionHandler(updatedBook)
                    
                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
    }
}
