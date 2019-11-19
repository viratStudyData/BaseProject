//
//  Utility.swift
//  Merge
//
//  Created by Apple on 03/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Utility: NSObject {
    static let shared : Utility = {
        let instance = Utility()
        return instance
    }()
    
    func convertArrayIntoJson(array: [[String : String]]?) -> String? {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: array ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var string = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
            string = string.replacingOccurrences(of: "\n", with: "") as String
            string = string.replacingOccurrences(of: "\\\"", with: "\"") as String
            string = string.replacingOccurrences(of: "\\", with: "") as String // removes \
            // string = string.replacingOccurrences(of: " ", with: "") as String
            string = string.replacingOccurrences(of: "/", with: "") as String
            
            return string as String
        }
            
        catch let error as NSError {
            
            print(error.description)
            return ""
        }
    }
    
    func dictToJasonString(dict: [String: AnyObject]) -> String? {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dict,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
           return theJSONText
        }
        return nil
    }
    
    
    // AddViewController
    func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        UIApplication.topViewController()?.addChild(viewController)
        
        // Add Child View as Subview
        UIApplication.topViewController()?.view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = UIApplication.topViewController()?.view.bounds ?? CGRect()
        
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Notify Child View Controller
        viewController.didMove(toParent: UIApplication.topViewController())
        
    }
    
    func remove(controller: UIViewController) {
        // Notify Child View Controller
        controller.willMove(toParent: nil)
        
        // Remove Child View From Superview
        controller.view.removeFromSuperview()
        
        // Notify Child View Controller
        controller.removeFromParent()
    }
}
