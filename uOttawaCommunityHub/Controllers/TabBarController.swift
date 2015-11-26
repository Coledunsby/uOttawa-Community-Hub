//
//  TabBarController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if CHUser.currentUser() == nil {
            self.performSegueWithIdentifier("ShowLogin", sender: self)
        }
    }

}
