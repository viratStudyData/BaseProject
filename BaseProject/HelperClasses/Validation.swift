//
//  Validation.swift
//  Paramount
//
//  Created by cbl24 on 15/02/17.
//  Copyright © 2017 Codebrew. All rights reserved.
//

import UIKit

//MARK: -----> Alert Message
enum AlertMessage : String{
    case firstName = "Please enter first name"
    case lastName = "Please enter last name"
    case enterEmail = "Please enter email address"
    case enterPassword = "Please enter password"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,15}$" // Password length 6-15
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{5,16}" // PhoneNo 10-14 Digits
    case acceptAll = ""
}

//MARK: -----> TextField Type
enum FieldType : String{
    case email = "Email"
    case password = "Password"
    case firstName = "First Name"
    case lastName = "Last Name"
    case name = "Name"

    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

//MARK: -----> Status
enum Status : String {
    case empty = "Please enter "
    case allSpaces = "Enter the "
    case password = "Your Password must contain 6-15 character"
    case valid
    case inValid = "Please enter a valid "
    case allZeros = "Please enter a Valid "
    case hasSpecialCharacter = " can only contain A-z, a-z characters only"
    case nameLength = " length should be in between 2 - 40 characters"
    
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    func message(type : FieldType) -> String? {
        switch self {
        case .hasSpecialCharacter: return type.localized + localized
        case .nameLength: return type.localized + localized
        case .valid: return nil
        case .password : return rawValue
        default: return localized + type.localized
        }
    }
}

extension String {
    
    func validate( userName : String? , password: String? ) -> Bool{
        let name = userName?.replacingOccurrences(of: " ", with: "")
        
        if (name?.isEmpty)! {
            Alerts.shared.show(alert: .error, message: AlertMessage.firstName.localized, type: .info)
            return false
            
        }else if !(isValid(type: .email, info: name) && isValid(type: .password, info: password)){
            return false
        }
        
        return true
    }
    
    func isValidRegEx(_ testStr: String, _ regex: RegEx) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex.rawValue)
        let result = stringTest.evaluate(with: testStr)
        return result
    }
    
    
    private func isValid(type : FieldType , info: String?) -> Bool {
        
        guard let validStatus = info?.handleStatus(fieldType : type) else {
            return true
        }
        
        let errorMessage = validStatus
        Alerts.shared.show(alert: .error, message: errorMessage , type : .info)
        return false
    }
    
    func handleStatus(fieldType : FieldType) -> String? {
        
        switch fieldType {
            
        case  .firstName , .lastName:
            return  isValidName.message(type: fieldType)
            
        case .name:
            return isValidFullName.message(type:fieldType)
            
        case .email   :
            return  isValidEmail.message(type: fieldType)
            
        case .password:
            return  isValid(password: 6, max: 15).message(type: fieldType)
            
        }
    }
    
    
    
    var isNumber1 : Bool {
        if let _ = NumberFormatter().number(from: self) {
            return true
        }
        return false
    }
    
    var hasSpecialCharcters : Bool {
        return  rangeOfCharacter(from: CharacterSet.letters.inverted) != nil
    }
    
    var isEveryCharcterZero : Bool{
        var count = 0
        self.forEach {
            if $0 == "0"{
                count += 1
            }
        }
        if count == self.count{
            return true
        }else{
            return false
        }
    }
    
    
    
    public func toString(format: String , date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    public var length: Int {
        return self.count
    }
    
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    
    public var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty
        }
    }
    
    func isValid() -> Status {
        if length <= 0 { return .empty }
        return .valid
    }
    
    func isValid(Regexpassword min: Int , max: Int) -> Status {
        if length <= 0 { return .empty }
        if isBlank  { return .allSpaces }
        if !(self.count >= min && self.count <= max){
            return .password
        }
        let isPasswordFormat = checkPassword(text: self)
        if !isPasswordFormat { return .password }
        return .valid
    }
    
    func checkPassword(text : String?) -> Bool{
        let regex = "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&!^~-]).{8,15})"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: text)
        if isMatched{
            return true
        }else {
            return false
        }
    }
    
    var isValidInformation : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        return .valid
    }
    
    var isValidExtension : Status {
        if hasSpecialCharcters { return .hasSpecialCharacter }
        if self.self.count < 6  && isNumber1 { return .valid }
        if self.self.count == 0 { return .valid }
        return .inValid
    }
    
    var isValidEmail : Status {
        if length <= 0 { return .empty }
        if isBlank { return .allSpaces }
        // if isEmail { return .valid }
        if !isValidRegEx(self, RegEx.email){return .inValid}
        
        return .valid
    }
    
    func  isValid(password min: Int , max: Int) -> Status {
        if length <= 0 { return .empty }
        if isBlank  { return .allSpaces }
        if !(self.count >= min && self.count <= max){
            return .password
        }
        return .valid
    }
    
    
    var isValidName : Status {
        if length <= 0 { return .empty }
        //        if isBlank { return .allSpaces }
        if hasSpecialCharcters { return .hasSpecialCharacter }
        //if !isValidRegEx(self, RegEx.alphabeticStringWithSpace){return .hasSpecialCharacter}
        if length < 2 || length > 40{return .nameLength}
        return .valid
    }
    
    var isValidFullName : Status {
        if length <= 0 { return .empty }
        if !isValidRegEx(self, RegEx.alphabeticStringWithSpace){return .hasSpecialCharacter}
        if length < 2 || length > 40{return .nameLength}
        return .valid
    }
    
    
}

extension String {
    func signUp(firstName : String?, lastName: String?,  email : String?, password : String? ) -> Bool {
        if isValid(type : .firstName , info : firstName) && isValid(type: .lastName, info: lastName) &&  isValid(type : .email , info : email) && isValid(type : .password , info : password){
            return true
            
        }
        return false
    }
}

