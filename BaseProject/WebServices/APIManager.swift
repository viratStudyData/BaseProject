
//  APIManager.swift
//  Teeshan
//
//  Created by Sierra 4 on 01/08/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation
import NVActivityIndicatorView


class APIManager : NSObject {
    
    typealias Completion = (Response) -> ()
    static let shared = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    func request(with api : Router , completion : @escaping Completion )  {
        
        if api.isLoaderNeeded() {
            self.showHUD()
        }
        
        httpClient.postRequest(withApi: api, success: {[weak self] (dictionary, responseData) in
            self?.dissmissHUD()
            guard let response = dictionary, response is [String : Any], let data = responseData else {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.somethingWentWrong()))
                
                return
            }
            
            print("Response Json: \(response)")
            
            let data1 = try? JSONDecoder().decode(BasicResponse.self, from: data)
            
            guard let responseObj:BasicResponse = data1 else {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.somethingWentWrong()))
                return
            }
            
            if responseObj.statusCode == ResponseCodes.sessionExpired.rawValue {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.sessionExpired), object: nil)
                completion(Response.failure(responseObj.statusCode ?? 0,/responseObj.message))
                return
            }
            
            if responseObj.statusCode == ResponseCodes.success.rawValue || responseObj.statusCode == ResponseCodes.successCreated.rawValue {
        
                let object : AnyObject?
                object = api.handle(responseObj: data)
                completion(Response.success(object))
                return
                
            } else  {
                
                completion(Response.failure(responseObj.statusCode ?? 0,/responseObj.message))
            }
            
            }, failure: {[weak self] (error) in
                self?.dissmissHUD()
                print("Response error : \(error?._code ?? 0)")
                
                if error?._code == NSURLErrorTimedOut || error?._code == NSURLErrorCannotConnectToHost || error?._code == NSURLErrorCannotFindHost {
                    completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.serverNotReachable()))
                    
                } else if error?._code == NSURLErrorNetworkConnectionLost || error?._code == NSURLErrorNotConnectedToInternet {
                    completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.noInternetConnection()))
                    
                } else {
                    completion(Response.failure((error?._code)!,(/error?.localizedDescription)))
                }
        })
    }
    
    func request (withImages api : Router , images : [(String,UIImage)]?  , completion : @escaping Completion )  {
        
        if api.isLoaderNeeded() {
            self.showHUD()
        }
        
        httpClient.postRequestWithImages(withApi: api, images: images, success: { [weak self] (dictionary, responseData) in
            self?.dissmissHUD()
            
            guard let response = dictionary, response is [String : Any], let data = responseData else {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.somethingWentWrong()))
                return
            }
            print(response)
            
            let data1 = try? JSONDecoder().decode(BasicResponse.self, from: data)
            
            guard let responseObj = data1 else {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.somethingWentWrong()))
                return
            }
            
            if responseObj.statusCode == ResponseCodes.sessionExpired.rawValue {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.sessionExpired), object: nil)
                completion(Response.failure(responseObj.statusCode ?? 0,/responseObj.message))
                return
            }
            
            if responseObj.statusCode == ResponseCodes.success.rawValue || responseObj.statusCode == ResponseCodes.successCreated.rawValue {
                
                let object : AnyObject?
                object = api.handle(responseObj: data)
                completion(Response.success(object))
                return
                
            } else  {
                
                completion(Response.failure(responseObj.statusCode ?? 0,/responseObj.message))
            }
            
        }) { [weak self] (error) in
            self?.dissmissHUD()
            print("Response error : \(error?._code ?? 0)")
            
            if error?._code == NSURLErrorTimedOut || error?._code == NSURLErrorCannotConnectToHost || error?._code == NSURLErrorCannotFindHost {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.serverNotReachable()))
                
            } else if error?._code == NSURLErrorNetworkConnectionLost || error?._code == NSURLErrorNotConnectedToInternet {
                completion(Response.failure(ResponseCodes.noResponse.rawValue,ResponseMessages.noInternetConnection()))
                
            } else {
                completion(Response.failure((error?._code)!,/(error?.localizedDescription)))
            }
        }
    }
    
    //MARK: HUD
    func showHUD() {
        DispatchQueue.main.async {
            let activity = ActivityData.init(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: NVActivityIndicatorType.ballTrianglePath, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activity, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        }
    }
    
    func dissmissHUD() {
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
            }
        }
    }
}
