//
//  APIHandler.swift
//
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation

//MARK: -----> Registration End Point
extension RegistrationEndPoint {
    
    func handle(responseObj : Data) -> AnyObject? {
        switch self {
            case .signUp(_):
                guard let response = try? JSONDecoder().decode(BasicResponse2<UserModel>.self, from: responseObj) else { return nil }
                
                return response
            
            default:
                let response = try? JSONDecoder().decode(BasicResponse.self, from: responseObj)
                return response
            
        }
    }
}
