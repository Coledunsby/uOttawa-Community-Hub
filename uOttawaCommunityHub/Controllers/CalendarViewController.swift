//
//  CalendarViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import FSCalendar
import DateTools

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, TableCellAnimatorFromProtocol {

    var allEvents: [CHEvent] = []
    var events: [CHEvent] = []
    var lastSelectedIndexPath: NSIndexPath?
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.delegate = self
        
        if CHUser.currentUser() != nil {
            fetchData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.delegate = nil
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHEvent.query()
        query?.limit = 1000
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.allEvents.removeAll()
            
            for object in objects! {
                self.allEvents.append(object as! CHEvent)
            }
            
            self.calendar.reloadData()
            self.calendar(self.calendar, didSelectDate: (self.calendar.selectedDate == nil) ? self.calendar.today : self.calendar.selectedDate)
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapChangeModeButton(sender: UIButton) {
        if (calendar.scope == .Month) {
            let date = (calendar.selectedDate == nil) ? calendar.today : calendar.selectedDate
            
            calendar.setScope(.Week, animated: false)
            calendarHeightConstraint.constant = 110
            calendar.setCurrentPage(date, animated: true)
            navigationItem.rightBarButtonItem?.title = "Month"
        } else {
            calendar.setScope(.Month, animated: false)
            calendarHeightConstraint.constant = 300
            navigationItem.rightBarButtonItem?.title = "Week"
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(events.count, 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < events.count {
            let event = events[indexPath.row]
            
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as! EventTableViewCell
            cell.nameLabel.text = event.name.uppercaseString
            cell.distanceLabel.text = "\(Int((CHUser.currentUser()?.location.distanceInMilesTo(event.location))!))mi"
            
            if let image = event.image {
                image.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    cell.backgroundImageView?.image = UIImage(data: data!)
                })
            } else {
                cell.backgroundImageView.image = UIImage(named: "eventImage")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoEvents")!
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        lastSelectedIndexPath = indexPath
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < events.count {
            performSegueWithIdentifier("ShowEvent", sender: self)
        }
    }
    
    // MARK: - FSCalendarDataSource
    
    func calendar(calendar: FSCalendar!, subtitleForDate date: NSDate!) -> String! {
        return nil
    }
    
    func calendar(calendar: FSCalendar!, imageForDate date: NSDate!) -> UIImage! {
        return nil
    }
    
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        for event in allEvents {
            if (event.startDate.isSameDay(date)) {
                return true
            }
        }
        return false
    }
    
    // MARK: - FSCalendarDelegate
    
    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
        events.removeAll()
        
        for event in allEvents {
            if (event.startDate.isSameDay(date)) {
                events.append(event)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - TableCellAnimatorFromProtocol
    
    func selectedCellView() -> UIView {
        let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!)!
        let snapshot = cell.snapshotViewAfterScreenUpdates(false)
        snapshot.frame = cell.convertRect(cell.bounds, toView: view)
        return snapshot
    }
    
    func selectedCellImage() -> UIImage {
        let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!)!
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        cell.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return image
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return (operation != .Pop) ? TableCellAnimator() : nil
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(EventViewController) {
            (segue.destinationViewController as! EventViewController).event = events[lastSelectedIndexPath!.row]
        }
    }
    
}
