//
//  UIAlertView+Additions.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func alert(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        return alertController
    }
    
    static func success(message: String?) -> UIAlertController {
        return alert("Success!", message: message)
    }
    
    static func error(message: String?) -> UIAlertController {
        return alert("Error!", message: message)
    }
    
}