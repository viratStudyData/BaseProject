//
//  APIConstants.swift
//  
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation

internal struct APIPaths {
    
    
    static let baseURL = "http://54.191.145.142:8000/" //Dev
    
    
    static let singUp                       = "user/register"

}

enum Keys: String {
    case email                  = "email"
    case firstName              = "firstName"
    case lastName               = "lastName"
    case password               = "password"
    
}

enum ResponseCodes : Int {
    case noResponse         = 0
    case success            = 200
    case successCreated     = 201
    case badRequest         = 400
    case sessionExpired     = 401
    case notFound           = 404
    case notRegigsterWithFB = 403
    
}

enum ResponseMessages : String {
    case email_not_found        = "EMAIL_NOT_FOUND"
    case incorrect_password     = "INVALID_PASS"
    case phoneNotFound          = "PHONE_NOT_FOUND"
    
    static func somethingWentWrong() -> String {
        return "Something went wrong. Please try again after sometime."
    }
    
    static func serverNotReachable() -> String {
        return "Unable to connect to server. Please try again after sometime"
    }
    
    static func noInternetConnection() -> String {
        return "Please check your internet connection"
    }
}

enum Response {
    case success(AnyObject?)
    case failure(Int,String)
    
}

typealias OptionalDictionary = [String : Any]?

struct Parameters {
    //Login
    static let signUp: [Keys] = [.firstName, .lastName, .email, .password]
    
}
