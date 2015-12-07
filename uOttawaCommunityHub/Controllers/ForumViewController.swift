//
//  ForumViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import DateTools

class ForumViewController: UITableViewController {

    var forumPosts: [CHForumPost] = []
    
    // MARK: - View Lifeycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHForumPost.query()
        query?.orderByDescending("createdAt")
        query?.includeKey("user")
        query?.limit = 1000
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.forumPosts.removeAll()
            
            for object in objects! {
                self.forumPosts.append(object as! CHForumPost)
            }
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumPosts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let forumPost = forumPosts[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! ForumPostTableViewCell
        cell.nameLabel.text = forumPost.name
        cell.infoLabel.text = forumPost.user.name() + " | " + NSDate.timeAgoSinceDate(forumPost.createdAt)
        cell.replyCountLabel.text = "–"
        
        let query = CHForumReply.query()
        query?.whereKey("forumPost", equalTo: forumPost)
        query?.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
            cell.replyCountLabel.text = "\(count)"
        })
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ForumPostViewController) {
            (segue.destinationViewController as! ForumPostViewController).forumPost = forumPosts[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
}
