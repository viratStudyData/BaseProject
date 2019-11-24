//
//  UITextViewPlaceholder.swift
//  Merge
//
//  Created by Apple on 25/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

//MARK: -----> Check Box
class CheckBox: UIButton {
    
    // Images
    @IBInspectable var checkedImage: UIImage?
    @IBInspectable var uncheckedImage: UIImage?
    @IBInspectable var selectedBackgroundColor: UIColor = UIColor.clear
    @IBInspectable var unSelectedBackgroundColor: UIColor = UIColor.clear
    @IBInspectable var selectedTextColor: UIColor = UIColor.clear
    @IBInspectable var unSelectedTextColor: UIColor = UIColor.clear
    
    
    // Bool property
    @IBInspectable var isChecked: Bool = false {
        didSet{
            if isChecked {
                self.setImage(checkedImage, for: .normal)
                self.backgroundColor = selectedTextColor
                self.setTitleColor(selectedTextColor, for: .normal)
                
            }else {
                self.setImage(uncheckedImage, for: .normal)
                self.backgroundColor = unSelectedTextColor
                self.setTitleColor(unSelectedTextColor, for: .normal)
                
            }
            
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) throws {
        switch sender == self {
        case true:
            isChecked = !isChecked
        default: break
        }
    }
    
    
}

//MARK: -----> TextView With Placeholder
class TextViewplaceholder: UITextView, UITextViewDelegate {
    
    @IBInspectable var placeholder: String?
    @IBInspectable var placeholderColor: UIColor?
    
    @IBInspectable var textValue: String {
        get {
            if self.text == placeholder {
                return ""
            }
            return self.text
        }
        set {
            text = newValue
        }
    }
    
    override func awakeFromNib() {
        delegate = self
        textColor = UIColor.lightGray
        text = (textValue == "") ? placeholder : textValue
        textColor = (placeholderColor != nil) ? placeholderColor : UIColor.lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text == placeholder {
            text = ""
            textColor = UIColor.black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == "" {
            text = placeholder
            textColor = (placeholderColor != nil) ? placeholderColor : UIColor.lightGray
            
        }
    }
    
}
