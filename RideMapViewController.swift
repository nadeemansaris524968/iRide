//
//  RideMapViewController.swift
//  iRide
//
//  Created by Nihitha,Bhimireddy on 3/15/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import MapKit
import UIKit


class RideMapViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var menuButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        manager =  CLLocationManager()
        manager.delegate =  self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {

            let latitude = NSString (string: places.last!["startLat"]!).doubleValue
            let longitude = NSString(string: places.last!["startLon"]!).doubleValue
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated: true)
            
            let annotation:MKPointAnnotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = latitude
            
            annotation.coordinate.longitude = longitude
            
            annotation.title = "Start: \(places.last!["Start"]!)"
            
            //annotation.subtitle = places[activePlace]["End"]
            
            self.mapView.addAnnotation(annotation)
            
            
            let endLat = NSString(string: places.last!["endLat"]!).doubleValue
            let endLon = NSString(string: places.last!["endLon"]!).doubleValue
            let endCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(endLat, endLon)
            let endRegion:MKCoordinateRegion = MKCoordinateRegionMake(endCoordinate, span)
            let endAnnotation:MKPointAnnotation = MKPointAnnotation()
            endAnnotation.coordinate.latitude = endLat
            endAnnotation.coordinate.longitude = endLon
            endAnnotation.title = "End: \(places.last!["End"]!)"
            self.mapView.addAnnotation(endAnnotation)

        }
        
        else {
            let latitude = NSString(string: places[activePlace]["startLat"]!).doubleValue
            let longitude = NSString(string: places[activePlace]["startLon"]!).doubleValue
            let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let latDelta:CLLocationDegrees = 0.01
            let lonDelta:CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
            self.mapView.setRegion(region, animated: true)
            
            let annotation:MKPointAnnotation = MKPointAnnotation()
            
            annotation.coordinate.latitude = latitude
            
            annotation.coordinate.longitude = longitude
            
            annotation.title = "Start: \(places[activePlace]["Start"]!)"
            
            //annotation.subtitle = places[activePlace]["End"]
            
            self.mapView.addAnnotation(annotation)
            
            
            
            let endLat = NSString(string: places[activePlace]["endLat"]!).doubleValue
            let endLon = NSString(string: places[activePlace]["endLon"]!).doubleValue
            let endCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(endLat, endLon)
            let endRegion:MKCoordinateRegion = MKCoordinateRegionMake(endCoordinate, span)
            let endAnnotation:MKPointAnnotation = MKPointAnnotation()
            endAnnotation.coordinate.latitude = endLat
            endAnnotation.coordinate.longitude = endLon
            endAnnotation.title = "End: \(places[activePlace]["End"]!)"
            self.mapView.addAnnotation(endAnnotation)

        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBOutlet weak var mapView: MKMapView!

    var manager:CLLocationManager!
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var userLocation:CLLocation = locations[0] as! CLLocation
        
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        
        
        var latDelta:CLLocationDegrees = 0.01
        
        var lonDelta:CLLocationDegrees = 0.01
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
}
