//
//  JWValidateText.swift
//  CustomTextfield
//
//  Created by Jenelle Walker on 1/6/15.
//  Copyright (c) 2015 Jenelle Walker. All rights reserved.
//

import Foundation
import UIKit

@objc public enum FieldType : Int {
    case None
    case Password
    case Name
    case PhoneNumber
    case Zipcode
    case Email
}

public class JWValidation : NSObject  {
    
    private var passwordRegex: String =  "(?=^.{6,255}$)((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*"
    private var nonEmailStrictRegex: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    private var strictEmailRegex: String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
    private var strict: Bool = true
    private var longZip: Bool = false
    private var nameReq: Int = 3
    
    public class var shared : JWValidation {
        struct Static {
            static let instance : JWValidation = JWValidation()
        }
        
        return Static.instance
    }
    
    public func setPasswordRegex(regex: String) {
        self.passwordRegex = regex
    }
    
    public func setEmailStrictRegex(regex:String) {
        self.strictEmailRegex = regex
    }
    
    public func setEmailNonStrictRegex(regex:String) {
        self.nonEmailStrictRegex = regex;
    }
    
    public func setEmailStrict(strict: Bool) {
        self.strict = strict
    }
    
    public func setNameRequirement(req: Int) {
        self.nameReq = req
    }
    
    public func setLongZipCode(longZip: Bool) {
        self.longZip = longZip
    }
    
    func validateText(input: String, type: FieldType) -> Bool {
        var result: Bool
        switch(type) {
        case .Zipcode:
            result = isValid5Zip(input)
        case .Email:
            result = isValidEmail(input, strict: self.strict)
        case .Name:
            result = isTextAtLeast(nameReq, text: input)
        case .None:
            result = true
        case .Password:
            result = isValidPassword(input, regex: self.passwordRegex)
        case .PhoneNumber:
            result = isValidPhone(input)
        }
        
        return result
    }
    
    func isValidEmail(text: String, strict:Bool._ObjectiveCType?) -> Bool {
        let useStrict = (strict != nil) ? strict : false
        
        let emailRegex = (useStrict != false) ? self.strictEmailRegex : self.nonEmailStrictRegex
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        let result =  email.evaluateWithObject(text)
        return result
    }
    
    func isValidPassword(text: String, regex: String) -> Bool {
        let password = NSPredicate(format:"SELF MATCHES %@", regex)
        let result =  password.evaluateWithObject(text)
        return result
    }
    
    func isTextEqualTo(length: Int, text: String) -> Bool {
        return text.utf16.count == length
    }
    
    func isTextAtLeast(length: Int, text: String) -> Bool {
        return text.utf16.count >= length
    }
    
    func isValidPhone(text: String) -> Bool {
        let numericString = getNumbers(text)
        return isTextEqualTo(10, text: numericString) || isTextEqualTo(11, text: numericString)
    }
    
    func isValid5Zip(text: String) -> Bool {
        let numericString = getNumbers(text)
        if longZip {
            return isTextEqualTo(9, text: numericString)
        }
        return isTextEqualTo(5, text: numericString)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func getNumbers(text: String) -> String {
        let numericComponents = text.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "1234567890").invertedSet)
        return numericComponents.joinWithSeparator("")
    }
}

protocol CanValidateInput {
    func validate(type: FieldType, ended: ((Self, Bool) -> ())?, began: ((Self) -> ())?, changed: ((Self) -> ())?)
}

public final class ValidatedTextField : UITextField, CanValidateInput {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func validate(type: FieldType, ended: ((ValidatedTextField, Bool) -> ())?, began: ((ValidatedTextField) -> ())?, changed: ((ValidatedTextField) -> ())?) {
        if ended != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidEndEditingNotification, object: self, queue: nil) { note in
                let result: Bool = JWValidation.shared.validateText(self.text!, type: type)
                ended!(self, result)
            }
        }
        
        if began != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidBeginEditingNotification, object: self, queue: nil) { note in
                began!(self)
            }
        }
        
        if changed != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: self, queue: nil) { note in
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
    
    public func validate(type: FieldType, ended: ((ValidatedTextView, Bool) -> ())?, began: ((ValidatedTextView) -> ())?, changed: ((ValidatedTextView) -> ())?) {
        if ended != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidEndEditingNotification, object: self, queue: nil) { note in
                let result: Bool = JWValidation.shared.validateText(self.text!, type: type)
                ended!(self, result)
            }
        }
        
        if began != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidBeginEditingNotification, object: self, queue: nil) { note in
                began!(self)
            }
        }
        
        if changed != nil {
            NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: self, queue: nil) { note in
                changed!(self)
            }
        }
    }
}