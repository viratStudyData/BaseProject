//
//  APIRoutes.swift
//  ChillaxPartner
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation
import Alamofire

protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(responseObj : Data) -> AnyObject?
    func isLoaderNeeded() -> Bool
    func encoding() -> ParameterEncoding
    
}

extension Sequence where Iterator.Element == Keys {
    
    func map(values: [Any?]) -> OptionalDictionary {
        
        var params = [String : Any]()
        let newContainer = zip(self,values)
        
        for (key,element) in newContainer {
            
            params[key.rawValue] = element
        }
        return params
        
    }
}
