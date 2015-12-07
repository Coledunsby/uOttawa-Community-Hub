//
//  LocationViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-06.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import SVGeocoder

protocol LocationViewControllerDelegate {
    func locationViewControllerDidSelectLocation(location: CLLocationCoordinate2D)
}

class LocationViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var placemark: SVPlacemark!
    var delegate: LocationViewControllerDelegate?
    var found = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.text = placemark.name
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !found {
            zoomToLocation(placemark.coordinate)
            found = true
        }
    }
    
    // MARK: - Private Functions
    
    func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        var region = MKCoordinateRegion()
        region.center = coordinate
        region.span.latitudeDelta = min(mapView.region.span.latitudeDelta, 0.2)
        region.span.longitudeDelta = min(mapView.region.span.longitudeDelta, 0.2)
        mapView.setRegion(region, animated: true)
    }

    func zoomToUserLocation() {
        zoomToLocation(mapView.userLocation.coordinate)
    }
    
    // MARK: - IBActions
    
    @IBAction func locateButtonTapped(sender: AnyObject) {
        zoomToUserLocation()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if found {
            SVGeocoder.reverseGeocode(mapView.centerCoordinate, completion: { (placemarks, urlResponse, error) -> Void in
                if placemarks.count > 0 {
                    self.placemark = placemarks[0] as! SVPlacemark
                    self.searchBar.text = self.placemark.name
                }
            })
            
            delegate?.locationViewControllerDidSelectLocation(mapView.centerCoordinate)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        var searchBarTextField: UITextField?
        
        for subview in searchBar.subviews[0].subviews {
            if subview.isKindOfClass(UITextField) {
                searchBarTextField = subview as? UITextField
                break
            }
        }
        
        searchBarTextField?.enablesReturnKeyAutomatically = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        let searchText = searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if searchText == "" || searchText == placemark.name {
            searchBar.text = placemark.name
        } else {
            SVGeocoder.geocode(searchBar.text, completion: { (placemarks, urlResponse, error) -> Void in
                if placemarks.count > 0 {
                    self.placemark = placemarks[0] as! SVPlacemark
                    self.mapView.setRegion(self.placemark.region, animated: true)
                }
            })
        }
    }
    
}
