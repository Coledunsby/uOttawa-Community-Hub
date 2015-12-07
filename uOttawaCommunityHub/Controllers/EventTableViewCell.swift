//
//  EventTableViewCell.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        overlayView.backgroundColor = UIColor(gradientStyle: .TopToBottom, withFrame: overlayView.frame, andColors: [UIColor.clearColor(), UIColor.blackColor()])
    }
    
}
