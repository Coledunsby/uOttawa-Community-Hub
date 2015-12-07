//
//  ClubViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubViewController: UIViewController {

    var club: CHClub!
    var pageViewController: UIPageViewController!
    var eventsVC: ClubEventsViewController!
    var membersVC: ClubMembersViewController!
    var infoVC: ClubInfoViewController!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func backButtonTapped(button: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func eventsButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== eventsVC {
            pageViewController.setViewControllers([eventsVC], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    @IBAction func membersButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== membersVC {
            pageViewController.setViewControllers([membersVC], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    @IBAction func infoButtonTapped(button: UIButton) {
        if self.pageViewController.viewControllers![0] !== infoVC {
            pageViewController.setViewControllers([infoVC], direction: .Forward, animated: false, completion: nil)
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
