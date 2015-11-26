//
//  AppDelegate.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse
        Parse.setApplicationId("aOlRkN6W0yidl61FW9RlCWk5eu11jefGKoOBOcXb", clientKey: "gs2bPpfHgx35xvBOxUDSeU2xdxfuXsQUIBXPEdIO")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Status Bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Navigation Bar
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().barTintColor = FlatSkyBlue()
        UINavigationBar.appearance().translucent = false;
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 16)!], forState: .Normal)
        
        return true
    }

}

