//
//  CreateEventViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import DateTools
import iOSBlocks
import MBProgressHUD
import Parse
import StaticDataTableViewController
import SVGeocoder
import TGCameraViewController
import UITextView_Placeholder

class CreateEventViewController: StaticDataTableViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIToolbarDelegate, LocationViewControllerDelegate, RepeatViewControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var startDateCell: UITableViewCell!
    @IBOutlet weak var startDatePickerCell: UITableViewCell!
    @IBOutlet weak var repeatCell: UITableViewCell!
    @IBOutlet weak var uploadImageCell: UITableViewCell!
    @IBOutlet weak var deleteImageCell: UITableViewCell!
    @IBOutlet weak var imageCell: UITableViewCell!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    
    var club: CHClub!
    var event: CHEvent?
    var tapGR: UITapGestureRecognizer!
    var imageData: NSData?
    var placemark: SVPlacemark?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event == nil {
            event = CHEvent()
            event?.club = club
            event?.user = CHUser.currentUser()!
            event?.name = ""
            event?.info = ""
            event?.startDate = NSDate()
            event?.recurrenceType = RecurrenceType.None.rawValue
            
            if let location = CHUser.currentUser()?.location {
                event?.location = location
            } else {
                event?.location = PFGeoPoint()
            }
        }
        
        tapGR = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = UIEdgeInsetsZero
        descriptionTextView.text = ""
        descriptionTextView.placeholder = "What should people know about this event?"
        
        updateLocation()
        updateRecurrenceType()
        
        insertTableViewRowAnimation = .Fade
        deleteTableViewRowAnimation = .Fade
        hideSectionsWithHiddenRows = true
        
        cell(imageCell, setHidden: true)
        cell(deleteImageCell, setHidden: true)
        cell(startDatePickerCell, setHidden: true)
        
        reloadDataAnimated(false)
    }
    
    // MARK: - Private Functions
    
    func dismissKeyboard() {
        view.endEditing(true)
        view.removeGestureRecognizer(tapGR)
    }
    
    func updateLocation() {
        SVGeocoder.reverseGeocode((event?.location.coreLocation().coordinate)!) { (placemarks, urlResponse, error) -> Void in
            if placemarks.count > 0 {
                self.placemark = placemarks[0] as? SVPlacemark
                self.locationLabel.text = self.placemark!.name
            } else {
                self.locationLabel.text = "N/A"
            }
        }
    }
    
    func updateRecurrenceType() {
        if event?.recurrenceType == RecurrenceType.None.rawValue {
            repeatLabel.text = "Never"
        } else if event?.recurrenceType == RecurrenceType.Daily.rawValue {
            repeatLabel.text = "Every Day"
        } else if event?.recurrenceType == RecurrenceType.Weekly.rawValue {
            repeatLabel.text = "Every Week"
        } else {
            repeatLabel.text = "Every Month"
        }
    }
    
    func uploadImage(image: UIImage) {
        imageData = UIImageJPEGRepresentation(image, 0.5)
        imageView.image = UIImage(data: imageData!)
        
        cell(uploadImageCell, setHidden: true)
        cell(imageCell, setHidden: false)
        cell(deleteImageCell, setHidden: false)
        
        reloadDataAnimated(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        let name = nameTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let description = descriptionTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if name == "" {
            presentViewController(UIAlertController.error("Your event needs a name."), animated: true, completion: nil)
        } else {
            MBProgressHUD.showHUDAddedTo(view, animated: true)
            
            event?.name = name!
            event?.info = description
            event?.startDate = startDatePicker.date
            
            func completion() {
                event?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if succeeded {
                        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentViewController(UIAlertController.error(error?.localizedDescription), animated: true, completion: nil)
                    }
                })
            }
            
            if let imageData = imageData {
                let imageFile = PFFile(data: imageData)
                imageFile?.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    if succeeded {
                        self.event?.image = imageFile
                        completion()
                    } else {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        self.presentViewController(UIAlertController.error(error?.localizedDescription), animated: true, completion: nil)
                    }
                })
            } else if imageView.image != nil {
                completion()
            } else {
                event?.image = nil
                completion()
            }
        }
    }
    
    @IBAction func datePickerValueChanged(datePicker: UIDatePicker) {
        if datePicker === startDatePicker {
            startDateLabel.text = datePicker.date.formattedDateWithStyle(.MediumStyle)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 4 && indexPath.row == 0 && !cellIsHidden(imageCell) {
            return 170
        } else if indexPath.section == 3 {
            return max(100, descriptionTextView.sizeThatFits(CGSize(width: descriptionTextView.frame.size.width, height: CGFloat.max)).height + 25)
        } else if indexPath.section == 2 && indexPath.row == 1 && !cellIsHidden(startDatePickerCell) {
            return 163
        } else {
            return 44
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 4 {
            if indexPath.row == 0 && !cellIsHidden(uploadImageCell) {
                presentViewController(TGAlbum.imagePickerControllerWithDelegate(self), animated: true, completion: nil)
            } else if indexPath.row == 1 && !cellIsHidden(deleteImageCell) {
                imageView.image = nil
                imageData = nil
                
                cell(uploadImageCell, setHidden: false)
                cell(imageCell, setHidden: true)
                cell(deleteImageCell, setHidden: true)
                
                reloadDataAnimated(true)
            }
        } else if indexPath.section == 3 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            cell(startDatePickerCell, setHidden: !cellIsHidden(startDatePickerCell))
            reloadDataAnimated(true)
        } else if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        view.addGestureRecognizer(tapGR)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        view.removeGestureRecognizer(tapGR)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        view.addGestureRecognizer(tapGR)
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Bottom, animated: true)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        view.removeGestureRecognizer(tapGR)
    }
    
    func textViewDidChange(textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: .Bottom, animated: true)
    }
    
    // MARK: - UIToolbarDelegate
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .Bottom
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        uploadImage(TGAlbum.imageWithMediaInfo(info))
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - LocationViewControllerDelegate
    
    func locationViewControllerDidSelectLocation(location: CLLocationCoordinate2D) {
        event?.location = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        updateLocation()
    }
    
    // MARK: - RepeatViewControllerDelegate
    
    func repeatViewControllerDidSelectRecurrenceType(recurrenceType: Int) {
        event?.recurrenceType = recurrenceType
        updateRecurrenceType()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(LocationViewController) {
            let locationVC = segue.destinationViewController as! LocationViewController
            locationVC.placemark = placemark
            locationVC.delegate = self
        } else if segue.destinationViewController.isKindOfClass(RepeatViewController) {
            let repeatVC = segue.destinationViewController as! RepeatViewController
            repeatVC.event = event
            repeatVC.delegate = self
        }
    }

}
