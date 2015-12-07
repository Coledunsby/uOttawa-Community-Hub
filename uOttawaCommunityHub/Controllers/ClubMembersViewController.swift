//
//  ClubMembersViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubMembersViewController: UITableViewController {

    var club: CHClub!
    var members: [CHUser] = []
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = club.members.query()
        query.orderByAscending("lastName")
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.members.removeAll()
            
            for object in objects! {
                self.members.append(object as! CHUser)
            }
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let member = members[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel!.text = member.name()
        
        return cell
    }

}
