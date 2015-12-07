//
//  RepeatViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-06.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

protocol RepeatViewControllerDelegate {
    func repeatViewControllerDidSelectRecurrenceType(recurrenceType: Int)
}

class RepeatViewController: UITableViewController {

    @IBOutlet weak var neverTableViewCell: UITableViewCell!
    @IBOutlet weak var dailyTableViewCell: UITableViewCell!
    @IBOutlet weak var weeklyTableViewCell: UITableViewCell!
    @IBOutlet weak var monthlyTableViewCell: UITableViewCell!

    var event: CHEvent!
    var delegate: RepeatViewControllerDelegate?
    var cells: [UITableViewCell]!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cells = [neverTableViewCell, dailyTableViewCell, weeklyTableViewCell, monthlyTableViewCell]
        
        neverTableViewCell.accessoryType = (event.recurrenceType == RecurrenceType.None.rawValue) ? .Checkmark : .None
        dailyTableViewCell.accessoryType = (event.recurrenceType == RecurrenceType.Daily.rawValue) ? .Checkmark : .None
        weeklyTableViewCell.accessoryType = (event.recurrenceType == RecurrenceType.Weekly.rawValue) ? .Checkmark : .None
        monthlyTableViewCell.accessoryType = (event.recurrenceType == RecurrenceType.Monthly.rawValue) ? .Checkmark : .None
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        delegate?.repeatViewControllerDidSelectRecurrenceType(indexPath.row)
    }
    
}
