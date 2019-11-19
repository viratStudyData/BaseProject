//
//  HTTPClient.swift
//  ChillaxPartner
//
//  Created by Sierra 4 on 09/03/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpClientSuccess = (Any?, Data?) -> ()
typealias HttpClientFailure = (Error?) -> ()

class HTTPClient {
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : Router  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        var headers:[String:String] = ["authorization": ""]
        let params = api.parameters
        let fullPath = api.baseURL + api.route
        let method = api.method
        
        var token = UserSingleton.shared.accessToken
        if token == nil || token == ""{
            token = ""
        }else {
            headers = ["authorization":("bearer " + /token)]
        }
        
        
        print(fullPath)
        debugPrint("TOKEN: \(headers)")
        print(params ?? [:])
        print("Method: \(api.method)")
        Alamofire.request(fullPath, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                success(data, response.data)
                
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    func postRequestWithImages(withApi api : Router,images : [(String, UIImage)]?, success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure){
        
        guard let params = api.parameters else {failure(nil); return}
        let fullPath = api.baseURL + api.route

        var headers:[String:String] = ["authorization": ""]
        var token = UserSingleton.shared.accessToken
        
        if token == nil {
            token = ""
            
        }else {
            headers = ["Accept" : "application/json", "Content-Type": "multipart/form-data", "authorization":("bearer " + /token)]
            
        }
        
        print("Method Type: \(api.method)")
        print(fullPath)
        debugPrint("TOKENs: \(headers)")
        
        print(params)

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let arrayImages = images{
                for (i, (key, image)) in arrayImages.enumerated() {
                
                    guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                        return }
                        multipartFormData.append(imageData, withName: key, fileName: "image\(i+1).jpg", mimeType: "image/jpg")
                }
            }
            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: fullPath, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_,_):
                
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        success(data, response.data)
                    case .failure(let error):
                        failure(error)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}
