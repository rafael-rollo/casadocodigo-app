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
    
    func authenticate(_ user: User,
                      withPassword password: String,
                      completionHandler: @escaping (Authentication) -> Void,
                      failureHandler: @escaping () -> Void) {
        let headers: HTTPHeaders = ["Content-type": "application/json", "Accept": "application/json"]
        let authentication = AuthenticationRequest(email: user.email, password: password)
        
        AF.request(UserAuthentication.authBasePath, method: .post, parameters: authentication, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: Authentication.self) { response in
                switch response.result {
                case .success:
                    guard let authenticationToken = response.value else { return }
                    completionHandler(authenticationToken)

                case let .failure(error):
                    debugPrint(error)
                    failureHandler()
                }
            }
        
    }
}
