//
//  FiltersViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class FiltersViewController: UITableViewController {

    var allFilters = NSMutableArray()
    var selectedFilters: NSMutableArray!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedFilters = CHUser.currentUser()?.filters
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHFilter.query()
        query?.orderByAscending("name")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects {
                self.allFilters.removeAllObjects()
                
                for object in objects {
                    self.allFilters.addObject(object as! CHFilter)
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    private func indexOfFilter(filter: CHFilter) -> Int {
        for var i = 0; i < selectedFilters.count; i++ {
            if filter.objectId == selectedFilters[i].objectId {
                return i
            }
        }
        return -1
    }
    
    // MARK: - IBActions
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        CHUser.currentUser()?.filters = selectedFilters
        CHUser.currentUser()?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filter = allFilters[indexPath.row] as! CHFilter
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = filter.name
        cell.accessoryType = (indexOfFilter(filter) == -1) ? .None : .Checkmark
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let filter = allFilters[indexPath.row] as! CHFilter
        let index = indexOfFilter(filter)
        
        if index == -1 {
            selectedFilters.addObject(filter)
        } else {
            selectedFilters.removeObjectAtIndex(index)
        }
        
        tableView.reloadData()
    }
    
}
