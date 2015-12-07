//
//  CreateAccountViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD
import ChameleonFramework

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Create Account"
        
        createAccountButton.layer.cornerRadius = 2.0
        createAccountButton.backgroundColor = FlatGreenDark()
        
        for textField in [firstNameTextField, lastNameTextField, emailTextField, studentNumberTextField, passwordTextField, confirmTextField] {
            textField.superview!.layer.cornerRadius = 2.0
            textField.superview!.layer.borderWidth = 1.0
            textField.superview!.layer.borderColor = UIColor.whiteColor().CGColor
            textField.superview?.backgroundColor = .clearColor()
            textField.textColor = .whiteColor()
            
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTouchDown(button: UIButton) {
        button.backgroundColor = FlatGreen()
    }
    
    @IBAction func buttonTouchUp(button: UIButton) {
        button.backgroundColor = FlatGreenDark()
    }
    
    @IBAction func createAccountButtonTapped(button: UIButton) {
        view.endEditing(true)
        
        let firstName = firstNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let lastName = lastNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let studentNumber = studentNumberTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text!
        let confirm = confirmTextField.text!
      
        if firstName == "" || lastName == "" || email == "" || studentNumber == "" || password == "" || confirm == "" {
            presentViewController(UIAlertController.error("Please complete all fields."), animated: true, completion: nil)
            
            if firstName == "" {
                firstNameTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if lastName == "" {
                lastNameTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if email == "" {
                emailTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if studentNumber == "" {
                studentNumberTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if password == "" {
                passwordTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if confirm == "" {
                confirmTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
        } else if studentNumber.characters.count != 7 {
            presentViewController(UIAlertController.error("Invalid student number."), animated: true, completion: nil)
            studentNumberTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
        } else if password.characters.count < 6 {
            presentViewController(UIAlertController.error("Passwords do not match."), animated: true, completion: nil)
            passwordTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
        } else if password != confirm {
            presentViewController(UIAlertController.error("Password must be at least 6 characters long."), animated: true, completion: nil)
            confirmTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            let user = CHUser()
            user.username = studentNumber
            user.firstName = firstName
            user.lastName = lastName
            user.email = email
            user.password = password
            
            user.signUpInBackgroundWithBlock({ (succeeded, error) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if succeeded {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    var errorMessage = error?.localizedDescription
                    if error!.code == 125 {
                        errorMessage = "Invalid email address."
                    } else if error!.code == 202 {
                        errorMessage = "An account already exists with that student number."
                    } else if error!.code == 203 {
                        errorMessage = "An account already exists with that email address."
                    }
                    self.presentViewController(UIAlertController.error(errorMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.superview?.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return false
    }

}
