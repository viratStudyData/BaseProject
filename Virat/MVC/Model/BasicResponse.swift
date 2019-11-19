//
//  BasicResponse.swift
//  SwiftDemo
//
//  Created by Sierra 4 on 09/06/17.
//  Copyright © 2017 codebrew. All rights reserved.
//

import UIKit
class BasicResponse: Decodable {
    
    var statusCode:Int?
    var message:String?
    
    init(statusCode: Int, message: String) {
        self.statusCode = statusCode
        self.message = message
        
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode, message
        
    }
}

class BasicResponse2<T:Codable>: Codable {
    
    var info: T?
    
    enum CodingKeys: String, CodingKey {
        case info = "info"
    }
    
    
}


