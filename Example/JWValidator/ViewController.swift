//
//  ViewController.swift
//  JWValidator
//
//  Created by Jenelle Walker on 11/13/2015.
//  Copyright (c) 2015 Jenelle Walker. All rights reserved.
//

import UIKit
import JWValidator

class ViewController: UIViewController {
    @IBOutlet weak var textfield: ValidatedTextField!
    @IBOutlet weak var textview: ValidatedTextView!
    @IBOutlet weak var anotherTextfield: ValidatedTextField!
    @IBOutlet weak var charLimit: UILabel!
    
    var limit = 20
    
    let validationInstance = JWValidation.shared;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let endedEditing = { (input: AnyObject, valid: Bool) -> Void in
            if !valid {
                if let textfield = input as? UITextField {
                    textfield.textColor = UIColor.redColor()
                } else if let textview = input as? UITextView {
                    textview.textColor = UIColor.redColor()
                }
            }
        }
        
        let beganEditing = { (input: AnyObject) -> Void in
            if let textfield = input as? UITextField {
                textfield.textColor = UIColor.blackColor()
            } else if let textview = input as? UITextView {
                textview.textColor = UIColor.blackColor()
            }
        }
        
        let changed = { (input: AnyObject) -> Void in
            if let textfield = input as? UITextField {
                if (textfield.text!.utf16.count > self.limit) {
                    self.charLimit.textColor = UIColor.redColor()
                } else {
                    self.charLimit.textColor = UIColor.grayColor()
                }
                let remaining = self.limit - textfield.text!.utf16.count
                self.charLimit.text = "\(remaining)"
            } else if let textview = input as? UITextView {
                if (textview.text.utf16.count > self.limit) {
                    self.charLimit.textColor = UIColor.redColor()
                } else {
                    self.charLimit.textColor = UIColor.grayColor()
                }
                let remaining = self.limit - textview.text.utf16.count
                self.charLimit.text = "\(remaining)"
            }
        }
        
        let newTextfield: ValidatedTextField = ValidatedTextField(frame: CGRectMake(20, 28, 100, 30))
        newTextfield.borderStyle = UITextBorderStyle.RoundedRect
        
        newTextfield.validate(FieldType.Email, ended: endedEditing, began: beganEditing, changed: nil)
        
        self.view.addSubview(newTextfield)
        
        self.textfield.validate(FieldType.Email, ended: endedEditing, began: beganEditing, changed:nil);
        self.anotherTextfield.validate(FieldType.PhoneNumber, ended: endedEditing, began: beganEditing, changed: nil)
        self.textview.validate(FieldType.None, ended: nil, began: nil, changed: changed)
        
        self.charLimit.text = "\(self.limit)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(validationInstance)
    }
}


