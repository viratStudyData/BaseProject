//
//  UserModel.swift
//  Virat
//
//  Created by VD on 11/19/19.
//  Copyright © 2019 VD. All rights reserved.
//

import UIKit

class UserModel: Codable {
    var id: String?
    var email, fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, fullName
        
    }
}
