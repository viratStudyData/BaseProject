//
//  Constants.swift
//  Merge
//
//  Created by Apple on 24/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static var theme = #colorLiteral(red: 0.2517416477, green: 0.5646591187, blue: 0.6219832301, alpha: 1)
    static var borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
}

enum DateFormat  {
    
    case dd_MMMM_yyyy
    case dd_MM_yyyy
    case dd_MM_yyyy2
    case yyyy_MM_dd
    case hh_mm_a
    case yyyy_MM_dd_hh_mm_a
    case yyyy_MM_dd_hh_mm_a2
    case dateWithTimeZone
    case dd_MMM_yyyy
    case MM_yy
    case yyyy
    
    func get() -> String{
        
        switch self {
            
        case .dd_MMMM_yyyy : return "dd MMMM, yyyy"
        case .dd_MM_yyyy : return "dd-MM-yyyy"
        case .dd_MM_yyyy2 : return "dd/MM/yyyy"
        case .yyyy_MM_dd : return "yyyy-MM-dd"
        case .hh_mm_a : return "hh:mm a"
        case .yyyy_MM_dd_hh_mm_a : return  "yyyy-MM-dd hh:mm a"
        case .yyyy_MM_dd_hh_mm_a2 : return  "dd MMM yyyy, hh:mm a"
        case  .dateWithTimeZone : return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        case .dd_MMM_yyyy : return "dd MMM yyyy"
        case .MM_yy: return "MM/yy"
        case .yyyy: return "yyyy"
            
        }
    }
}

//MARK: -----> Notifications
struct Notifications {
    static let sessionExpired = "SessionExpired"
    
}

