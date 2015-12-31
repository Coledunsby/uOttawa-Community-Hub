//
//  EventViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-05.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SVGeocoder

class EventViewController: UIViewController, TableCellAnimatorToProtocol, MKMapViewDelegate {

    @IBOutlet weak var snapshotImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var event: CHEvent!
    var placemark: SVPlacemark!
    var found = false

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share")
        
        descriptionLabel.text = event.info
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !found {
            zoomToLocation(event.location.coreLocation().coordinate)
            found = true
        }
    }
    
    // MARK: - Private Functions
    
    private func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.center = coordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if found {
            SVGeocoder.reverseGeocode(mapView.centerCoordinate, completion: { (placemarks, urlResponse, error) -> Void in
                if placemarks.count > 0 {
                    self.placemark = placemarks[0] as! SVPlacemark
                }
            })
        }
    }
    
}
