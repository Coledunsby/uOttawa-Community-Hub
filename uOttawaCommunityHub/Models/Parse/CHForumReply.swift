//
//  CHForumReply.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class CHForumReply: PFObject, PFSubclassing {

    @NSManaged var user: CHUser
    @NSManaged var forumPost: CHForumPost
    @NSManaged var text: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "ForumReply"
    }
    
}
