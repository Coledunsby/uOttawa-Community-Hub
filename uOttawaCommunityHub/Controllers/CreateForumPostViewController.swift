//
//  CreateForumPostViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateForumPostViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var tapGR: UITapGestureRecognizer!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGR = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = UIEdgeInsetsZero
        descriptionTextView.text = ""
    }
    
    // MARK: - Private Functions
    
    func dismissKeyboard() {
        view.endEditing(true)
        view.removeGestureRecognizer(tapGR)
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        let name = nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let description = descriptionTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if name == "" {
            presentViewController(UIAlertController.error("Your club needs a name."), animated: true, completion: nil)
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            let forumPost = CHForumPost()
            forumPost.user = CHUser.currentUser()!
            forumPost.name = name!
            forumPost.info = description
            forumPost.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
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
        if indexPath.section == 0 {
            return 50
        } else {
            return max(100, descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: CGFloat.max)).height + 25)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        } else {
            descriptionTextView.becomeFirstResponder()
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
