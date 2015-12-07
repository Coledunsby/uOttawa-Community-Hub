//
//  ClubsViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class ClubsViewController: UITableViewController, UISearchBarDelegate, TableCellAnimatorFromProtocol {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var allClubs: [CHClub] = []
    var clubs: [CHClub] = []
    var lastSelectedIndexPath: NSIndexPath?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "ClubTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        let searchBarTextField = searchBar.valueForKey("searchField") as? UITextField
        searchBarTextField?.textColor = .whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.delegate = self
        
        fetchData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.delegate = nil
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHClub.query()
        query?.orderByAscending("name")
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
        
        if let image = club.image {
            image.getDataInBackgroundWithBlock({ (data, error) -> Void in
                cell.backgroundImageView?.image = UIImage(data: data!)
            })
        } else {
            cell.backgroundImageView.image = UIImage(named: "yoga")
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        lastSelectedIndexPath = indexPath
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowClub", sender: self)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        var searchBarTextField: UITextField?
        
        for subview in searchBar.subviews[0].subviews {
            if subview.isKindOfClass(UITextField) {
                searchBarTextField = subview as? UITextField
                break
            }
        }
        
        searchBarTextField?.enablesReturnKeyAutomatically = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clubs = allClubs
        } else {
            clubs = allClubs.filter({ $0.name.lowercaseString.containsString(searchText.lowercaseString) })
        }

        tableView.reloadData()
    }
    
    // MARK: - TableCellAnimatorFromProtocol
    
    func selectedCellView() -> UIView {
        let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!)!
        let snapshot = cell.snapshotViewAfterScreenUpdates(false)
        snapshot.frame = cell.convertRect(cell.bounds, toView: view)
        return snapshot
    }
    
    func selectedCellImage() -> UIImage {
        let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!)!
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (operation != .Pop) ? TableCellAnimator() : nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ClubViewController) {
            (segue.destinationViewController as! ClubViewController).club = clubs[lastSelectedIndexPath!.row]
        }
    }
    
}
