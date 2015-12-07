//
//  CreateClubViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateClubViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    var tapGR: UITapGestureRecognizer!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGR = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = UIEdgeInsetsZero
        descriptionTextView.text = ""
    }
    
    // MARK: - Private Functions
    
    private func dismissKeyboard() {
        view.endEditing(true)
        view.removeGestureRecognizer(tapGR)
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        let name = nameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let description = descriptionTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let email = emailTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let website = websiteTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if name == "" {
            presentViewController(UIAlertController.error("Your club needs a name."), animated: true, completion: nil)
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            let club = CHClub()
            club.name = name
            club.info = description
            club.email = email
            club.website = website
            club.admins.addObject(CHUser.currentUser()!)
            club.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if succeeded {
                    self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.presentViewController(UIAlertController.error(error?.localizedDescription), animated: true, completion: nil)
                }
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return max(100, descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: CGFloat.max)).height + 25)
        } else {
            return 50
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        } else if indexPath.section == 1 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 2 {
            emailTextField.becomeFirstResponder()
        } else {
            websiteTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        view.addGestureRecognizer(tapGR)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.removeGestureRecognizer(tapGR)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        view.addGestureRecognizer(tapGR)
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Bottom, animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        view.removeGestureRecognizer(tapGR)
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Bottom, animated: true)
    }
    
}
