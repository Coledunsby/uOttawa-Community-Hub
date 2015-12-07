//
//  ClubInfoViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import MessageUI

class ClubInfoViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var club: CHClub!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = club.email
        websiteLabel.text = club.website
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            if (MFMailComposeViewController.canSendMail()) {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setSubject("uOttawa Community Hub")
                mailComposer.setToRecipients([emailLabel.text!])
                
                presentViewController(mailComposer, animated: true, completion: nil)
            }
        } else {
            if let url = NSURL(string: websiteLabel.text!) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
