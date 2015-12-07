//
//  CreateForumReplyViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateForumReplyViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    var forumPost: CHForumPost!
    var tapGR: UITapGestureRecognizer!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGR = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = UIEdgeInsetsZero
        descriptionTextView.text = ""
        descriptionTextView.becomeFirstResponder()
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
        let description = descriptionTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if description == "" {
            presentViewController(UIAlertController.error("Your reply can't be empty."), animated: true, completion: nil)
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            let forumReply = CHForumReply()
            forumReply.user = CHUser.currentUser()!
            forumReply.forumPost = forumPost
            forumReply.text = description
            forumReply.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
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
        return max(100, descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: CGFloat.max)).height + 25)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        descriptionTextView.becomeFirstResponder()
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        view.addGestureRecognizer(tapGR)
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        view.removeGestureRecognizer(tapGR)
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }

}
