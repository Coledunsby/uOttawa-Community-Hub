//
//  FiltersViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {

    var filters: [CHFilter] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHFilter.query()
        query?.orderByAscending("name")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.filters.removeAll()
            
            for object in objects! {
                self.filters.append(object as! CHFilter)
            }
            
            self.tableView.reloadData()
        })
    }
    
    private func indexOfFilter(filter: CHFilter) -> Int {
        for var i = 0; i < CHUser.currentUser()!.filters.count; i++ {
            if filter.objectId == CHUser.currentUser()!.filters[i].objectId {
                return i
            }
        }
        return -1
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filter = filters[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = filter.name
        cell.accessoryType = (indexOfFilter(filter) == -1) ? .None : .Checkmark
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let filter = filters[indexPath.row]
        let index = indexOfFilter(filter)
        
        if index == -1 {
            CHUser.currentUser()!.filters.addObject(filter)
        } else {
            CHUser.currentUser()!.filters.removeObjectAtIndex(index)
        }
        
        CHUser.currentUser()?.saveInBackground()
        
        tableView.reloadData()
    }
    
}
