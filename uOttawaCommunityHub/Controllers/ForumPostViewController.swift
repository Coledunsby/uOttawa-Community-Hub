//
//  ForumPostViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import DateTools

class ForumPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var forumPost: CHForumPost!
    var forumReplies: [CHForumReply] = []
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = forumPost.name
        infoLabel.text = forumPost.info
        dateLabel.text = forumPost.user.name() + " | " + NSDate.timeAgoSinceDate(forumPost.createdAt)
        
        tableView.estimatedRowHeight = 86
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHForumReply.query()
        query?.whereKey("forumPost", equalTo: forumPost)
        query?.orderByDescending("createdAt")
        query?.includeKey("user")
        query?.limit = 1000
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.forumReplies.removeAll()
            
            for object in objects! {
                self.forumReplies.append(object as! CHForumReply)
            }
            
            self.tableView.reloadData()
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forumReplies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let forumReply = forumReplies[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! ForumReplyTableViewCell
        cell.infoLabel.text = forumReply.text
        cell.dateLabel.text = forumReply.user.name() + " | " + NSDate.timeAgoSinceDate(forumReply.createdAt)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(UINavigationController) {
            let navigationController = segue.destinationViewController as! UINavigationController
            let createReplyVC = navigationController.viewControllers.first as! CreateForumReplyViewController
            createReplyVC.forumPost = forumPost
        }
    }
    
}
