
//
//  ViewController.swift
//  Validator
//
//  Created by Jenelle Walker on 1/9/15.
//  Copyright (c) 2015 Jenelle Walker. All rights reserved.
//

import UIKit
import swift_text_validator

class ViewController: UIViewController {
    @IBOutlet weak var textfield: ValidatedTextField!
    @IBOutlet weak var textview: ValidatedTextView!
    @IBOutlet weak var anotherTextfield: ValidatedTextField!
    @IBOutlet weak var charLimit: UILabel!
    
    var limit = 20
    
    let validationInstance = Validation.shared;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let endedEditing = { (input: AnyObject, valid: Bool) -> Void in
            if !valid {
                if let textfield = input as? UITextField {
                    textfield.textColor = UIColor.red
                } else if let textview = input as? UITextView {
                    textview.textColor = UIColor.red
                }
            }
        }
        
        let beganEditing = { (input: AnyObject) -> Void in
            if let textfield = input as? UITextField {
                textfield.textColor = UIColor.black
            } else if let textview = input as? UITextView {
                textview.textColor = UIColor.black
            }
        }
        
        let changed = { (input: AnyObject) -> Void in
            if let textfield = input as? UITextField {
                if (textfield.text!.utf16.count > self.limit) {
                    self.charLimit.textColor = UIColor.red
                } else {
                    self.charLimit.textColor = UIColor.gray
                }
                let remaining = self.limit - textfield.text!.utf16.count
                self.charLimit.text = "\(remaining)"
            } else if let textview = input as? UITextView {
                if (textview.text.utf16.count > self.limit) {
                    self.charLimit.textColor = UIColor.red
                } else {
                    self.charLimit.textColor = UIColor.gray
                }
                let remaining = self.limit - textview.text.utf16.count
                self.charLimit.text = "\(remaining)"
            }
        }
        
        let newTextfield: ValidatedTextField = ValidatedTextField(frame: CGRect(x:20, y:55, width:100, height:30))
        newTextfield.borderStyle = UITextBorderStyle.roundedRect
        
        newTextfield.validate(FieldType.email, ended: endedEditing, began: beganEditing, changed: nil)
        
        let newLabel: UILabel = UILabel(frame: CGRect(x: 20, y: 28, width: 300, height: 20))
        newLabel.text = "Programmatic Email Textfield"
        
        self.view.addSubview(newTextfield)
        self.view.addSubview(newLabel)
        
        self.textfield.validate(FieldType.email, ended: endedEditing, began: beganEditing, changed:nil);
        self.anotherTextfield.validate(FieldType.phoneNumber, ended: endedEditing, began: beganEditing, changed: nil)
        self.textview.validate(FieldType.none, ended: nil, began: nil, changed: changed)
        
        self.charLimit.text = "\(self.limit)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(validationInstance)
    }
}
