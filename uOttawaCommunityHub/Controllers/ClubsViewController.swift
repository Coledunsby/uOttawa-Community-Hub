//
//  ClubsViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubsViewController: UITableViewController, UISearchBarDelegate {

    var allClubs: [CHClub] = []
    var clubs: [CHClub] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "ClubTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHClub.query()
        query?.orderByDescending("name")
        query?.limit = 1000
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.allClubs.removeAll()
            
            for object in objects! {
                self.allClubs.append(object as! CHClub)
            }
            
            self.clubs = self.allClubs
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let club = clubs[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! ClubTableViewCell
        cell.nameLabel.text = club.name.uppercaseString
        cell.membersLabel.text = "–"
        
        club.members.query().countObjectsInBackgroundWithBlock { (count, error) -> Void in
            cell.membersLabel.text = "\(count)"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowClub", sender: self)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clubs = allClubs
        } else {
            clubs = allClubs.filter({ $0.name.lowercaseString.containsString(searchText.lowercaseString) })
        }

        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ClubViewController) {
            (segue.destinationViewController as! ClubViewController).club = clubs[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
