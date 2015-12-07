//
//  ClubEventsViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubEventsViewController: UITableViewController {

    var club: CHClub!
    var events: [CHEvent] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHEvent.query()
        query?.whereKey("club", equalTo: club)
        query?.orderByDescending("date")
        query?.limit = 1000
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.events.removeAll()
            
            for object in objects! {
                self.events.append(object as! CHEvent)
            }
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 100
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            return tableView.dequeueReusableCellWithIdentifier("AddCell")!
        } else {
            let event = events[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! EventTableViewCell
            cell.nameLabel.text = event.name
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            performSegueWithIdentifier("ShowEvent", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(EventViewController) {
            (segue.destinationViewController as! EventViewController).event = events[(tableView.indexPathForSelectedRow?.row)!]
        } else if segue.destinationViewController.isKindOfClass(UINavigationController) {
            let navigationController = segue.destinationViewController as! UINavigationController
            (navigationController.viewControllers[0] as! CreateEventViewController).club = club
        }
    }

}
