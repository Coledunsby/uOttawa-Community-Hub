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
    var locationUpdateTimer: NSTimer?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse
        Parse.setApplicationId("aOlRkN6W0yidl61FW9RlCWk5eu11jefGKoOBOcXb", clientKey: "gs2bPpfHgx35xvBOxUDSeU2xdxfuXsQUIBXPEdIO")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Status Bar
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Navigation Bar
        UINavigationBar.appearance().tintColor = FlatGreen()
        UINavigationBar.appearance().barTintColor = FlatBlack()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: FlatGreen(), NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: FlatGreen(), NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 16)!], forState: .Normal)
        
        // Tab Bar
        UITabBar.appearance().tintColor = FlatGreen()
        UITabBar.appearance().barTintColor = FlatBlack()
        UITabBar.appearance().translucent = false
        
        setupLocationManager()
        
        return true
    }
    
    func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            print("setting up location manager")
            
            CLLocationManager.sharedManager().requestWhenInUseAuthorization()
            
            updateLocation()
            
            locationUpdateTimer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateLocation", userInfo: nil, repeats: true)
        } else {
            print("location services disabled")
        }
    }
    
    func updateLocation() {
        if let user = CHUser.currentUser() {
            CLLocationManager.sharedManager().updateLocationWithDistanceFilter(CLLocationDistanceMax, andDesiredAccuracy: kCLLocationAccuracyBest, didUpdateLocations: { (list) -> Void in
                print("updating location...")
                let location = list.last! as! CLLocation
                user.location = PFGeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                user.saveInBackground()
            }, didFailWithError: { (error) -> Void in
                print("failed to update location (error: \(error.localizedDescription)")
            })
        }
    }

}

