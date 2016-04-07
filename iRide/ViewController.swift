//
//  ViewController.swift
//  iRide
//
//  Created by Ansari,Nadeem on 3/15/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

//var rides:[ride] = Ride()

var ride:Ride = Ride()

var myLocations: [CLLocation] = []
var myLocationsIndex:Int = 0

var startLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
var stopLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)

var myPausedLocations: [CLLocation] = []
var myPausedLocationsIndex:Int = 0

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var startLocationLatitude:CLLocationDegrees!
    var startLocationLongitude:CLLocationDegrees!
    
    var pausedLocationLatitude:CLLocationDegrees!
    var pausedLocationLongitude:CLLocationDegrees!
    
    
    var location = CLLocationManager()
    
    
    var destination = CLLocationCoordinate2DMake(0, 0)
    
    
    var pinCounter:Int = 0
    
    
    @IBOutlet weak var currentLocation: MKMapView!
    
    @IBOutlet weak var destinationLocation: MKMapView!
    
    @IBOutlet weak var endRide: UIButton!
   
    @IBOutlet weak var startRide: UIButton!
    
    @IBOutlet weak var pauseRide: UIButton!
    
    @IBAction func pauseRide(sender: UIButton) {
        
        //pinCounter++
      
        let pauseDropPin = MKPointAnnotation()
        pauseDropPin.coordinate = destination
        pauseDropPin.title = " "
        pauseDropPin.subtitle = " "
        currentLocation.addAnnotation(pauseDropPin)
        
        //print("Pin no. \(pinCounter)")
        location.stopUpdatingLocation()
        currentLocation.showsUserLocation = false
        pauseRide.hidden = true
        continueRide.hidden = false
        
                
        
        let geoCoder = CLGeocoder()
        let newLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        geoCoder.reverseGeocodeLocation(newLocation)
            {
                (placemarks, error) -> Void in
                
                let placeArray = placemarks as [CLPlacemark]!
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                
                // Address dictionary
                print(placeMark.addressDictionary)
                
                // Location name
                if let locationName = placeMark.addressDictionary?["Name"] as? NSString
                {
                    print(locationName)
                    pauseDropPin.title = "\(locationName)"
                    
                }
                
                // Street address
                if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString
                {
                    print(street)
                    
                }
                
                // City
                if let city = placeMark.addressDictionary?["City"] as? NSString
                {
                    print(city)
                    pauseDropPin.subtitle = "\(city)"
                }
                
                // Zip code
                if let zip = placeMark.addressDictionary?["ZIP"] as? NSString
                {
                    print(zip)
                    pauseDropPin.subtitle?.appendContentsOf( " "  + (zip as String)  as String)
                    //pauseDropPin.subtitle = "\(zip)"
                }
                
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? NSString
                {
                    print(country)
                    //pauseDropPin.subtitle = "\(country)"
                }
                
                
                
                myPausedLocations.append(newLocation)
                print("Created and added paused pin")
                
                
                
                //print("Paused location: \(myPausedLocations[myPausedLocationsIndex])")
                //myPausedLocationsIndex++
                
        }
        
       
        
    }
    @IBOutlet weak var continueRide: UIButton!
    @IBAction func continueRide(sender: UIButton) {
        
        location.startUpdatingLocation()
        currentLocation.showsUserLocation = true
        pauseRide.hidden = false
        continueRide.hidden = true
    }
    
    
    
    
    @IBAction func segmentedControlAction(sender: UISegmentedControl!) {
        
        
        
        switch (sender.selectedSegmentIndex) {
            
        case 0:
            
            currentLocation.mapType = .Standard
            
        case 1:
            
            currentLocation.mapType = .Satellite
            
        default: // or case 2
            
            currentLocation.mapType = .Hybrid
            
        }
        
    }
    
    
    
    @IBAction func startRide(sender: UIButton) {
        
        endRide.hidden = false
        startRide.hidden = true
        
        
        
        currentLocation.delegate = self
    }
    
    @IBAction func endRide(sender: UIButton) {
        
        let endRideDropPin = MKPointAnnotation()
        
         endRideDropPin.coordinate = destination
        
        
        
        location.stopUpdatingLocation()
        currentLocation.showsUserLocation = false

        currentLocation.addAnnotation(endRideDropPin)
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Discard Ride", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Discarded")
        })
        let saveAction = UIAlertAction(title: "Save Ride", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
            
            
            
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    @IBOutlet weak var slideOutMenuButton: UIBarButtonItem!
    
    

    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            
            slideOutMenuButton.target = self.revealViewController()
            
            slideOutMenuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        super.viewDidLoad()
        
        location.delegate = self
        
        location.desiredAccuracy = kCLLocationAccuracyBest
        
        location.requestWhenInUseAuthorization()
        
        location.startUpdatingLocation()
        
        currentLocation.showsUserLocation = true
        
        continueRide.hidden = true
        
        endRide.hidden = true
        
        
    }
    
    
    func locationManager(manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        myLocations.append(locations[0] as CLLocation)
        
        if myLocations.count == 1 {
            
            startLocationLatitude = myLocations[myLocationsIndex].coordinate.latitude
            
            startLocationLongitude = myLocations[myLocationsIndex].coordinate.longitude
            
            //print("Start location latitude \(startLocationLatitude) \n Start location longitude \(startLocationLongitude)")
            
            CLGeocoder().reverseGeocodeLocation(locations[0], completionHandler: { (placemarks, error) -> Void in
                
                var title = ""
                var subTitle = ""
                
                if (error == nil) {
                    let p = placemarks![0]
                    
                    var subThoroughfare:String = ""
                    var thoroughfare:String = ""
                    var locality:String = ""
                    var subLocality:String = ""
                    var subAdministrativeArea:String = ""
                    var postalCode:String = ""
                    var country:String = ""
                    
                    if (p.subThoroughfare != nil) {
                        subThoroughfare = (p.subThoroughfare)!
                    }
                    
                    if (p.thoroughfare != nil) {
                        thoroughfare = (p.thoroughfare)!
                    }
                    
                    if (p.locality != nil) {
                        locality = (p.locality)!
                    }
                    
                    if (p.subLocality != nil) {
                        subLocality = (p.subLocality)!
                    }
                    if (p.subAdministrativeArea != nil) {
                        subAdministrativeArea = (p.subAdministrativeArea)!
                    }
                    if (p.postalCode != nil) {
                        postalCode = (p.postalCode)!
                    }
                    if (p.country != nil) {
                        country = (p.country)!
                    }
                    
                    title = "\(subThoroughfare) \(thoroughfare) \(locality)"
                    subTitle = "\(subLocality) \(postalCode) \(country)"
                    
                    ride.addStartLocation(title)
                    
                }
            })
        }
        
        myLocationsIndex++
        
        let startPoint = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let startRegion = MKCoordinateRegion(center: startPoint, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        self.currentLocation.setRegion(startRegion, animated: true)

        if (myLocations.count > 1){
            
            let sourceIndex = myLocations.count - 1
            
            let destinationIndex = myLocations.count - 2

            let c1 = myLocations[sourceIndex].coordinate
            
            let c2 = myLocations[destinationIndex].coordinate
            
            var a = [c1, c2]

            destination = c2
            
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            
            currentLocation.addOverlay(polyline)

        }
        
        

    }

    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            
            polylineRenderer.strokeColor = UIColor.blueColor()
            
            polylineRenderer.lineWidth = 5
            
            return polylineRenderer
            
        }

        return nil
        
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        

}

}

