//
//  MapViewController.swift
//  FoodPicker
//
//  Created by Andrew Ball on 12/10/15.
//  Copyright © 2015 Andrew Ball. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var quickSearchLabel: UILabel!
    @IBOutlet weak var quickSearchValue: UISegmentedControl!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchRestaurantsLabel: UILabel!
    @IBOutlet weak var mileValue: UISegmentedControl!
    
    let request = MKLocalSearchRequest()
    var matchItems: [MKMapItem] = [MKMapItem]()
    var locationManager: CLLocationManager = CLLocationManager()
    var circle = MKCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        searchField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        request.naturalLanguageQuery = searchField.text
        searchField.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
        return true
    }
    
    @IBAction func quickSearchButton(sender: AnyObject) {
        mapView.removeAnnotations(mapView.annotations)
        if quickSearchValue.selectedSegmentIndex == 0 {
            request.naturalLanguageQuery = "Restaurants"
        }
        else {
            request.naturalLanguageQuery = "Fast Food"
        }
        
        self.performSearch()
        
    }
    
    
/*************Radius Circle*************/
    
    @IBAction func mileRadiusButton(sender: AnyObject) {
        self.mapView.delegate = self
        
        if self.mapView.overlays.count != 0 {
            self.mapView.removeOverlay(circle)
        }
        
        if mileValue.selectedSegmentIndex == 0 {
            if locationManager.location?.coordinate != nil {
                circle = MKCircle(centerCoordinate: (locationManager.location?.coordinate)!, radius: 8046.72 as CLLocationDistance)
                self.mapView.addOverlay(circle)
            }
        }
        else if mileValue.selectedSegmentIndex == 1 {
            if locationManager.location?.coordinate != nil { //if no user location won't show radius
                circle = MKCircle(centerCoordinate: (locationManager.location?.coordinate)!, radius: 16093.4 as CLLocationDistance)
                self.mapView.addOverlay(circle)
            }
        }
        else {
            if self.mapView.overlays.count != 0 {
                self.mapView.removeOverlay(circle)
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.redColor()
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
    }
    
    
/****************************************/
    
/*********Search Functionality***********/
    
    func performSearch() {
        matchItems.removeAll()
        //if locationManager.location?.coordinate != nil {
            //let center = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            //let region = MKCoordinateRegionMake(<#T##centerCoordinate: CLLocationCoordinate2D##CLLocationCoordinate2D#>, <#T##span: MKCoordinateSpan##MKCoordinateSpan#>)
       // }
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
    
/***************************************/
    
/********Location Functionality*********/
    
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
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            self.mapView.setRegion(region, animated: true)
            
            let horizontalAccuracy = location.horizontalAccuracy
            
            if horizontalAccuracy < 40 {
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error Detected: " + error.localizedDescription)
    }
    
/**************************************/
    
}



    


