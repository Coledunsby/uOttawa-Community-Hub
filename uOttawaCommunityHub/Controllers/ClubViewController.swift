//
//  ClubViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework

class ClubViewController: UIViewController, TableCellAnimatorToProtocol {

    @IBOutlet weak var eventsButton: UIButton!
    @IBOutlet weak var membersButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var leadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var snapshotImageView: UIImageView!
    
    var club: CHClub!
    var pageViewController: UIPageViewController!
    var eventsVC: ClubEventsViewController!
    var membersVC: ClubMembersViewController!
    var infoVC: ClubInfoViewController!
    
    // MARK: - IBActions
    
    @IBAction func eventsButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== eventsVC {
            pageViewController.setViewControllers([eventsVC], direction: .Forward, animated: false, completion: nil)
            
            eventsButton.setTitleColor(FlatGreen(), forState: .Normal)
            membersButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            infoButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            leadingSpaceConstraint.constant = eventsButton.frame.origin.x
        }
    }
    
    @IBAction func membersButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== membersVC {
            pageViewController.setViewControllers([membersVC], direction: .Forward, animated: false, completion: nil)
            
            eventsButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            membersButton.setTitleColor(FlatGreen(), forState: .Normal)
            infoButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            leadingSpaceConstraint.constant = membersButton.frame.origin.x
        }
    }
    
    @IBAction func infoButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== infoVC {
            pageViewController.setViewControllers([infoVC], direction: .Forward, animated: false, completion: nil)
            
            eventsButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            membersButton.setTitleColor(.lightGrayColor(), forState: .Normal)
            infoButton.setTitleColor(FlatGreen(), forState: .Normal)
            leadingSpaceConstraint.constant = infoButton.frame.origin.x
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(UIPageViewController) {
            eventsVC = storyboard?.instantiateViewControllerWithIdentifier("ClubEventsViewController") as! ClubEventsViewController
            membersVC = storyboard?.instantiateViewControllerWithIdentifier("ClubMembersViewController") as! ClubMembersViewController
            infoVC = storyboard?.instantiateViewControllerWithIdentifier("ClubInfoViewController") as! ClubInfoViewController
            
            eventsVC.club = club
            membersVC.club = club
            infoVC.club = club
            
            pageViewController = segue.destinationViewController as! UIPageViewController
            pageViewController.setViewControllers([eventsVC], direction: .Forward, animated: true, completion: nil)
        }
    }

}
