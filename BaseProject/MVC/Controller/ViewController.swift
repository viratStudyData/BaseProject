//
//  ViewController.swift
//  Virat
//
//  Created by VD on 11/19/19.
//  Copyright © 2019 VD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpAPI()
    }


}

//MARK: -----> API
extension ViewController {
    func signUpAPI() {
        APIManager.shared.request(with: RegistrationEndPoint.signUp(firstName: "a", lastName: "b", email: "df", password: "jjj"), completion: {[weak self] response in
            switch response {
            case .success(let res):
                guard let basicResponse = res as? BasicResponse2<UserModel>, let userData = basicResponse.info else {
                    return
                }
                
//                UserSingleton.shared.accessToken = userData.accessToken
//                let vc = PersonalInfoVC.getVC(.accountSetup)
//                vc.userData = userData
//                self?.pushVC(vc)
                
            case .failure(let message):
                Alerts.shared.show(alert: .alert, message: message.1, type: .info)
                
            }
        })
    }
    
    
}
