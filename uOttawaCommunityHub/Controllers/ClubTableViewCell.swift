//
//  ClubTableViewCell.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework

class ClubTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var membersImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        membersImageView.image = membersImageView.image?.imageWithRenderingMode(.AlwaysTemplate)
        membersImageView.tintColor = .whiteColor()
        
        overlayView.backgroundColor = UIColor(gradientStyle: .TopToBottom, withFrame: overlayView.frame, andColors: [UIColor.clearColor(), UIColor.blackColor()])
    }
    
}
