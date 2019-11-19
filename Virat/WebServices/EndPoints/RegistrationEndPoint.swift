//
//  RegistrationEndPoint.swift
//  Yeto
//
//  Created by MACMINI_CBL on 8/14/18.
//

import Foundation
import Alamofire

enum RegistrationEndPoint {
    case signUp( firstName: String?, lastName: String?, email: String?, password: String?)
    
}

extension RegistrationEndPoint: Router {    
    
    func encoding() -> ParameterEncoding {
        return URLEncoding.default
    }
    
    var route: String {
        switch self {
            case .signUp(_): return APIPaths.singUp
        }
    }
    
    var baseURL: String {
        return APIPaths.baseURL
        
    }
    
    var parameters: OptionalDictionary {
        
//        let deviceToken = UserSingleton.shared.deviceToken
        
        switch self {
            case .signUp(let firstName, let lastName, let email, let passowrd):
                return Parameters.signUp.map(values: [firstName, lastName, email, passowrd])
            
        }
    }
    
    var method: Alamofire.HTTPMethod {
//        switch self {
//            case .getIndustries(_), .getInterests(_), .getPersonas(_):
//                return .get
//            
//            default:
//                return .post
//        }
        return .post
    }
    
    func isLoaderNeeded() -> Bool {
        return true
    }
}
