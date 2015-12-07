//
//  PFGeoPoint+Additions.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-06.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

extension PFGeoPoint {
    
    func coreLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    
}