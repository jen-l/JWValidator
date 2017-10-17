//
//  ValidateText.swift
//  CustomTextfield
//
//  Created by Jenelle Walker on 1/6/15.
//  Copyright (c) 2015 Jenelle Walker. All rights reserved.
//

import Foundation
import UIKit

@objc public enum FieldType : Int {
    case none
    case password
    case name
    case phoneNumber
    case zipcode
    case email
}

open class Validation : NSObject  {
    
    fileprivate var passwordRegex: String =  "(?=^.{6,255}$)((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*"
    fileprivate var nonEmailStrictRegex: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    fileprivate var strictEmailRegex: String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    fileprivate var strict: Bool = true
    fileprivate var longZip: Bool = false
    fileprivate var nameReq: Int = 3
    
    open class var shared : Validation {
        struct Static {
            static let instance : Validation = Validation()
        }
        
        return Static.instance
    }
    
    open func setPasswordRegex(_ regex: String) {
        self.passwordRegex = regex
    }
    
    open func setEmailStrictRegex(_ regex:String) {
        self.strictEmailRegex = regex
    }
    
    open func setEmailNonStrictRegex(_ regex:String) {
        self.nonEmailStrictRegex = regex;
    }
    
    open func setEmailStrict(_ strict: Bool) {
        self.strict = strict
    }
    
    open func setNameRequirement(_ req: Int) {
        self.nameReq = req
    }
    
    open func setLongZipCode(_ longZip: Bool) {
        self.longZip = longZip
    }
    
    open func validateText(_ input: String, type: FieldType) -> Bool {
        var result: Bool
        switch(type) {
        case .zipcode:
            result = isValid5Zip(input)
        case .email:
            result = isValidEmail(input, strict: self.strict as Bool._ObjectiveCType)
        case .name:
            result = isTextAtLeast(nameReq, text: input)
        case .none:
            result = true
        case .password:
            result = isValidPassword(input, regex: self.passwordRegex)
        case .phoneNumber:
            result = isValidPhone(input)
        }
        
        return result
    }
    
    open func isValidEmail(_ text: String, strict:Bool._ObjectiveCType?) -> Bool {
        let useStrict = (strict != nil) ? strict : false
        
        let emailRegex = (useStrict != false) ? self.strictEmailRegex : self.nonEmailStrictRegex
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let result =  email.evaluate(with: text)
        return result
    }
    
    open func isValidPassword(_ text: String, regex: String) -> Bool {
        let password = NSPredicate(format:"SELF MATCHES %@", regex)
        let result =  password.evaluate(with: text)
        return result
    }
    
    open func isTextEqualTo(_ length: Int, text: String) -> Bool {
        return text.utf16.count == length
    }
    
    open func isTextAtLeast(_ length: Int, text: String) -> Bool {
        return text.utf16.count >= length
    }
    
    open func isValidPhone(_ text: String) -> Bool {
        let numericString = getNumbers(text)
        return isTextEqualTo(10, text: numericString) || isTextEqualTo(11, text: numericString)
    }
    
    open func isValid5Zip(_ text: String) -> Bool {
        let numericString = getNumbers(text)
        if longZip {
            return isTextEqualTo(9, text: numericString)
        }
        return isTextEqualTo(5, text: numericString)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open func getNumbers(_ text: String) -> String {
        let numericComponents = text.components(separatedBy: CharacterSet(charactersIn: "1234567890").inverted)
        return numericComponents.joined(separator: "")
    }
}

protocol CanValidateInput {
    func validate(_ type: FieldType, ended: ((Self, Bool) -> ())?, began: ((Self) -> ())?, changed: ((Self) -> ())?)
}

public final class ValidatedTextField : UITextField, CanValidateInput {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func validate(_ type: FieldType, ended: ((ValidatedTextField, Bool) -> ())?, began: ((ValidatedTextField) -> ())?, changed: ((ValidatedTextField) -> ())?) {
        if ended != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidEndEditing, object: self, queue: nil) { note in
                let result: Bool = Validation.shared.validateText(self.text!, type: type)
                ended!(self, result)
            }
        }
        
        if began != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self, queue: nil) { note in
                began!(self)
            }
        }
        
        if changed != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: self, queue: nil) { note in
                changed!(self)
            }
        }
    }
}

public final class ValidatedTextView : UITextView, CanValidateInput {
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func validate(_ type: FieldType, ended: ((ValidatedTextView, Bool) -> ())?, began: ((ValidatedTextView) -> ())?, changed: ((ValidatedTextView) -> ())?) {
        if ended != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidEndEditing, object: self, queue: nil) { note in
                let result: Bool = Validation.shared.validateText(self.text!, type: type)
                ended!(self, result)
            }
        }
        
        if began != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidBeginEditing, object: self, queue: nil) { note in
                began!(self)
            }
        }
        
        if changed != nil {
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextViewTextDidChange, object: self, queue: nil) { note in
                changed!(self)
            }
        }
    }
}
