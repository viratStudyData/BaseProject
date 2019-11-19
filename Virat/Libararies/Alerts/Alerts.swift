

import UIKit

typealias AlertBlock = (_ success: AlertTag) -> ()
typealias buttonAction = (_ action: TitleType) -> ()

enum AlertTag {
    case done
    case yes
    case no
}

class Alerts: NSObject {
    static let shared = Alerts()
    func show(alert title : TitleType , message : String? , type : ISAlertType){
        ISMessages.hideAlert(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            ISMessages.showCardAlert(withTitle: title.localized , message: /message , duration: 3.0 , hideOnSwipe: true , hideOnTap: true , alertType: type , alertPosition: .top , didHide: nil)
        }
    }
    
    func showAlert(title: String, msg: String, buttons: [TitleType], preferredStyle: UIAlertController.Style, tintColor: UIColor?,  block:buttonAction?) {
        
        let controller = UIAlertController(title: title, message: msg, preferredStyle: preferredStyle)
        for button in buttons{
            let action = UIAlertAction(title: button.rawValue , style: .default, handler: { (action) -> Void in
                block?(button)
            })
            controller.addAction(action)
        }
        
        controller.view.tintColor = tintColor ?? UIColor.theme
        
        UIApplication.topViewController()?.present(controller, animated: true) { () -> Void in
        }
        
    }
}



    

