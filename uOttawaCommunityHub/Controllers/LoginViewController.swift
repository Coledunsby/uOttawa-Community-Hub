//
//  LoginViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD
import ChameleonFramework

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var studentNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in buttons {
            button.layer.cornerRadius = 2.0
            button.backgroundColor = FlatGreen()
        }
        
        for textField in [studentNumberTextField, passwordTextField] {
            textField.superview?.layer.cornerRadius = 2.0
            textField.superview?.layer.borderWidth = 1.0
            textField.superview?.layer.borderColor = FlatGreen().CGColor
            textField.superview?.backgroundColor = .clearColor()
            
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: FlatGreen()])
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        if CHUser.currentUser() != nil {
            navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonTouchDown(button: UIButton) {
        button.backgroundColor = FlatGreenDark()
    }
    
    @IBAction func buttonTouchUp(button: UIButton) {
        button.backgroundColor = FlatGreen()
    }
    
    @IBAction func loginButtonTapped(button: UIButton) {
        view.endEditing(true)
        
        let studentNumber = studentNumberTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let password = passwordTextField.text!
        
        if studentNumber == "" || password == "" {
            presentViewController(UIAlertController.error("Please complete all fields."), animated: true, completion: nil)
            
            if studentNumber == "" {
                studentNumberTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
            
            if password == "" {
                passwordTextField.superview?.layer.borderColor = UIColor.redColor().CGColor
            }
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            CHUser.logInWithUsernameInBackground(studentNumber, password: password, block: { (user, error) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if user != nil {
                    self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let errorMessage = (error!.code == 101) ? "Incorrect student number or password." : error?.localizedDescription
                    self.presentViewController(UIAlertController.error(errorMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(button: UIButton) {
        let alertController = UIAlertController(title: "Forgot Password", message: "Enter your email address:", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (action) -> Void in
            let textField = alertController.textFields![0]
            let email = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            if email == "" {
                self.presentViewController(UIAlertController.error("Email address is required."), animated: true, completion: nil)
            } else {
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                CHUser.requestPasswordResetForEmailInBackground(email, block: { (succeeded, error) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if succeeded {
                        self.presentViewController(UIAlertController.success("Please check your email."), animated: true, completion: nil)
                    } else {
                        let errorMessage = (error!.code == 205) ? "No user found with that email address." : error?.localizedDescription
                        self.presentViewController(UIAlertController.error(errorMessage), animated: true, completion: nil)
                    }
                })
            }
        }))
        
        alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.keyboardType = .EmailAddress
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.superview?.layer.borderColor = FlatGreen().CGColor
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
