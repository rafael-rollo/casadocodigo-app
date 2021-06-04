//
//  UserAuthentication.swift
//  casadocodigo
//
//  Created by rafael.rollo on 02/06/21.
//

import UIKit
import Alamofire

class UserAuthentication: NSObject {

    static let authBasePath = "https://casadocodigo-api.herokuapp.com/api/auth"
    
    func authenticateUser(identifiedBy email: String,
                      withPassword password: String,
                      completionHandler: @escaping (User) -> Void,
                      failureHandler: @escaping (String) -> Void) {
        let headers: HTTPHeaders = ["Content-type": "application/json", "Accept": "application/json"]
        let authentication = AuthenticationRequest(email: email, password: password)
        
        AF.request(UserAuthentication.authBasePath, method: .post, parameters: authentication, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success:
                    guard let authenticatedUser = response.value else { return }
                    completionHandler(authenticatedUser)

                case let .failure(error):
                    debugPrint(error)
                    failureHandler(UserAuthentication.message(for: error))
                }
            }
        
    }
    
    private static func message(for error: AFError) -> String {
        switch error.responseCode {
        case 400:
            return "Email or password wrong!"
        
        default:
            return "Could not possible to authenticate. Try again later!"
        }
    }
}
