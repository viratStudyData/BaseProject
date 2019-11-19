//
//  Extensions.swift
//  CancerCoaches
//
//  Created by Apple on 10/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

extension NSObject {
    class var identifier: String {
        return String(describing: self)
    }
}

public typealias dateData = ((String, Double)?) -> ()

extension UITextField {
    
    @IBInspectable var leftPadding: Int {
        get { return 0 }
        set {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 20))
            leftView = paddingView
            leftViewMode = .always
            
        }
    }
    
    @IBInspectable var rightPadding: Int {
        get { return 0 }
        set {
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 20))
            rightView = paddingView
            rightViewMode = .always
            
        }
    }
}

extension String {
    // Trims white space and new line characters, returns a new string
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func textSize(fontName: String, size: CGFloat) -> CGSize {
        let font = UIFont(name: fontName, size: size)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let myText = self
        let size = (myText as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
        
    }
    
    func getDateFromMiliSecond(formate: String) -> String {
        let milisecond = self.toDouble()
       
        let dateVar =  Date(timeIntervalSince1970: (/milisecond / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return (dateFormatter.string(from: dateVar))
        
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.MM_yy.get()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        return dateFormatter.date(from:self)!
    }
    
    /// EZSE: Converts String to Int
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Double
    public func toDouble() -> Double? {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Float
    public func toFloat() -> Float? {
        if let num = NumberFormatter().number(from: self) {
            return num.floatValue
        } else {
            return nil
        }
    }
    
    /// EZSE: Converts String to Bool
    public func toBool() -> Bool? {
        let trimmedString = trimmed().lowercased()
        if trimmedString == "true" || trimmedString == "false" {
            return (trimmedString as NSString).boolValue
        }
        return nil
    }
    
}

///MARK: - Date extension
extension Date{
    
    var millisecondsSince1970: Double {
        
        return ((self.timeIntervalSince1970 * 1000.0).rounded()).abs
    }
    
    //date to string
    func dateToString(format:String)->String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format  //Your New Date format as per requirement change it own
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let newDate = dateFormatter.string(from: self)
        return newDate
        
    }
    
}

extension UIButton {
    func toggle() -> Bool {
        isSelected = (isSelected) ? false : true
        return isSelected
        
    }
    
    @IBInspectable
    open var exclusiveTouchEnabled : Bool {
        get {
            return self.isExclusiveTouch
        }
        set(value) {
            self.isExclusiveTouch = value
        }
    }
    
    func tabAction(selected: Bool) {
        isSelected = selected
        backgroundColor = isSelected ? #colorLiteral(red: 0.2517416477, green: 0.5646591187, blue: 0.6219832301, alpha: 1) : UIColor.clear
        setTitleColor(isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : UIColor.darkGray , for: .normal)
        
    }
    
    
}

extension UIView {
    //MARK: -----> Doted view
    func drawDottedLine() {
        self.layoutIfNeeded()
        let strokeColor = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [2,2] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}

extension UITableView {
    func  scrollAt(row: Int) {
        let indexPath = NSIndexPath(item: row, section: 0)
        scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
    }
}

extension UIApplication {
    /// EZSE: Run a block in background after app resigns activity
    public func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.endBackgroundTask(taskID)
        }
    }
    
    /// EZSE: Get the top most view controller from the base view controller; default param is UIWindow's rootViewController
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension Double {
    public var abs: Double {
        if self > 0 {
            return self
        } else {
            return -self
        }
    }
}
