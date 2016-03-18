//
//  DetailedViewController.swift
//  FoodPicker
//
//  Created by Andrew Ball on 12/15/15.
//  Copyright © 2015 Andrew Ball. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailedViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var matchItems: [MKMapItem] = [MKMapItem]()
    var passedRestaurant: String!
    var searchValue: String!
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchValue = passedRestaurant
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        performSearch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization Status Changed to \(status.rawValue)")
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.mapView.setRegion(region, animated: true)
            
            let horizontalAccuracy = location.horizontalAccuracy
            
            if horizontalAccuracy < 40 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func performSearch() {
        matchItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchValue
        request.region = self.mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({(response: MKLocalSearchResponse?, error: NSError?) in
            
            if error != nil {
                print("Error in Search: \(error!.localizedDescription)")
            }
            else if response?.mapItems.count == 0 {
                print("No Matches Found")
            }
            else {
                for item in response!.mapItems {
                    
                    self.matchItems.append(item as MKMapItem)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    self.mapView.addAnnotation(annotation)
                }
            }
        })
        
    }


    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error Detected: " + error.localizedDescription)
    }
    
    @IBAction func appleMapsButton(sender: AnyObject) {
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        
        print(String(latitude))
        print(String(longitude))
        
        let region: CLLocationDistance = 10000
        
        let coordinates = CLLocationCoordinate2DMake(latitude!, longitude!)
        let makeRegion = MKCoordinateRegionMakeWithDistance(coordinates, region, region)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: makeRegion.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: makeRegion.span)
        ]
    
        MKMapItem.openMapsWithItems(matchItems, launchOptions: options)
    }
    
}
