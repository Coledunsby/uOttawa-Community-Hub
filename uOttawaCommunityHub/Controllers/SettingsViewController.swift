//
//  SettingsViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UITableViewController {
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 {
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.removeObjectForKey("user")
            currentInstallation.saveInBackground()
            
            CHUser.logOut()
            
            tabBarController?.selectedIndex = 0
            tabBarController!.performSegueWithIdentifier("ShowLogin", sender: self)
        }
    }
    
}
