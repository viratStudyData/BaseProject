
import UIKit

class UserSingleton: NSObject {

    class var shared: UserSingleton {
        struct Static {
            static let instance: UserSingleton = UserSingleton()
        }
        return Static.instance
    }

    override init(){
        super.init()
    }

    deinit {
    }
    
    enum UDKeys: String{
        case userData = "userData"
        case deviceToken = "deviceToken"
        case accessToken = "accessToken"
        
        func save(_ value: Any) {
            UserDefaults.standard.set(value, forKey: self.rawValue)
            UserDefaults.standard.synchronize()
            
        }

        func fetch() -> Any? {
            guard let value = UserDefaults.standard.value(forKey: self.rawValue) else { return nil}
            return value
            
        }

        func remove() {
            UserDefaults.standard.removeObject(forKey: self.rawValue)
        }

    }
    
    var userData: UserModel? {
        
        get {
            guard let userData = UDKeys.userData.fetch() else {
                return nil
            }
            
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(UserModel.self, from: userData as! Data){
                return user
            }
            
            return nil
        }

        set{
            if let value = newValue{
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(value) {
                    UDKeys.userData.save(encoded)
                }
                
            }else{
                UDKeys.userData.remove()
            }
        }
    }
    
    var deviceToken : String?{
        get{
            guard let token = UDKeys.deviceToken.fetch() else{return "123456"}
            return token as? String ?? "123456"
        }
        set{
            if let value = newValue{
                UDKeys.deviceToken.save(value)
            }else{
                UDKeys.deviceToken.remove()
            }
        }
    }
    
    var accessToken : String?{
        get{
            guard let token = UDKeys.accessToken.fetch() else{return ""}
            return token as? String ?? ""
        }
        set{
            if let value = newValue{
                UDKeys.accessToken.save(value)
            }else{
                UDKeys.accessToken.remove()
            }
        }
    }

}


