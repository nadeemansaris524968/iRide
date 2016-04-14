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

var rides = [Ride(StartLocation: "", EndLocation: "")]

var ride:Ride = Ride(StartLocation: "", EndLocation: "")

var distanceBetweenCoordinates:Double = 0.0

var from:CLLocation!
var to:CLLocation!

var allLocations:[CLLocation] = []
var allLocationsIndex:Int = 0

var locationCounter:Int = 0

var speedArray:[Double] = []
var avgSpeed:Double = 0.0

var myLocations: [CLLocation] = []
var myLocationsIndex:Int = 0

var startLocation = CLLocationCoordinate2DMake(0.0, 0.0)
var stopLocation = CLLocationCoordinate2DMake(0.0, 0.0)

var myPausedLocations: [CLLocation] = []
var myPausedLocationsIndex:Int = 0

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var startLocationLatitude:CLLocationDegrees!
    var startLocationLongitude:CLLocationDegrees!
    
    var endLocationLatitude:CLLocationDegrees!
    var endLocationLongitude:CLLocationDegrees!
    
    var pausedLocationLatitude:CLLocationDegrees!
    var pausedLocationLongitude:CLLocationDegrees!
    
    
    var location = CLLocationManager()
    
    
    var destination = CLLocationCoordinate2DMake(0, 0)
    
    var endDestination:CLLocation!
    
    
    
    var pinCounter:Int = 0
    
    @IBOutlet weak var viewRideInfoBTN: UIButton!
    
    @IBAction func viewRideInfoBTN(sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var currentLocation: MKMapView!
    
    @IBOutlet weak var destinationLocation: MKMapView!
    
    @IBOutlet weak var endRide: UIButton!
   
    @IBOutlet weak var startRide: UIButton!
    
    @IBOutlet weak var pauseRide: UIButton!
    
    
    ///////////////////////////////////////////////////--------------------VIEW DID LOAD--------------------///////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            
            slideOutMenuButton.target = self.revealViewController()
            
            slideOutMenuButton.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        super.viewDidLoad()
    
        continueRide.hidden = true
        
        endRide.hidden = true
        
        if places.count == 1 {
            places.removeFirst()
            places.append(["Start":"Taj Mahal","End":"New Delhi", "startLat":"27.175277", "startLon":"78.042128"])
        }
        
        if distanceBetweenCoordinates > 0.0 {
            distanceBetweenCoordinates = 0.0
        }
        
        
        
        viewRideInfoBTN.hidden = true
        
        location.delegate = self
        
        location.desiredAccuracy = kCLLocationAccuracyBest
        
        location.requestWhenInUseAuthorization()
        
        currentLocation.showsUserLocation = true
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if distanceBetweenCoordinates > 0.0 {
            distanceBetweenCoordinates = 0.0
        }
        
        
    }
    
    ///////////////////////////////////////////////////--------------------PAUSE RIDE--------------------///////////////////////////////////////////////////
    
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
                print("Created and added paused pin to the map")
                
                
                
                //print("Paused location: \(myPausedLocations[myPausedLocationsIndex])")
                //myPausedLocationsIndex++
                
        }
        
       
        
    }
    
    @IBOutlet weak var continueRide: UIButton!
    
    
    ///////////////////////////////////////////////////--------------------CONTINUE RIDE--------------------///////////////////////////////////////////////////
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
    
    
    ///////////////////////////////////////////////////--------------------START RIDE--------------------///////////////////////////////////////////////////
    
    @IBAction func startRide(sender: UIButton) {
        
        endRide.hidden = false
        startRide.hidden = true
        
        location.startUpdatingLocation()
        
        
        
        currentLocation.delegate = self
//        rides.removeFirst()
    }
    
    
    ///////////////////////////////////////////////////--------------------END RIDE--------------------///////////////////////////////////////////////////
    
    @IBAction func endRide(sender: UIButton) {
        
        let endRideDropPin = MKPointAnnotation()
        
         endRideDropPin.coordinate = destination
        
        endRideDropPin.title = " "
        endRideDropPin.subtitle = " "
        
        var title = ""
        
        var subTitle = ""
        
        CLGeocoder().reverseGeocodeLocation(endDestination, completionHandler: { (placemarks, error) -> Void in
 
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
                
                ride.endLocation = title
                
                
                
                self.endLocationLatitude = self.endDestination.coordinate.latitude
                self.endLocationLongitude = self.endDestination.coordinate.longitude
                
                //ride.addEndLocation("\(endDestination.coordinate.latitude)")
//
//                print("End Ride location \(ride.endLocation)")
                
                print("End location lat : \(self.endLocationLatitude) \nEnd location lon: \(self.endLocationLongitude)")
            }
        })
        
        
        location.stopUpdatingLocation()
        currentLocation.showsUserLocation = false

        currentLocation.addAnnotation(endRideDropPin)
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .Alert)
        
        // 2
        let deleteAction = UIAlertAction(title: "Discard Ride", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Discarded")
        })
        let saveAction = UIAlertAction(title: "Save Ride", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
            
            //ride.endLocation = title
            
            print("End Ride location \(ride.endLocation)")
            
            rides.append(ride)
            
//            for var eachRide in rides {
//                print("Start location: \(eachRide.startLocation) \n End location: \(eachRide.endLocation)")
//            }
            
            //Use this method if you get nils in lats and lons for start location.
            
            if self.startLocationLatitude == nil && self.startLocationLongitude == nil {
                
                print("Start lat and lon were nil")
                
                self.startLocationLatitude = 37.331833
                self.startLocationLongitude = -122.029556
            }
            
            endRideDropPin.title = title
            endRideDropPin.subtitle = subTitle
            
            for eachSpeed in speedArray {
                avgSpeed += eachSpeed
            }
            
            avgSpeed = avgSpeed/(Double(locationCounter))
            
            places.append(["Start":"\(ride.startLocation)", "End":"\(ride.endLocation)", "startLat":"\(self.startLocationLatitude)", "startLon":"\(self.startLocationLongitude)", "endLat":"\(self.endLocationLatitude)", "endLon":"\(self.endLocationLongitude)", "dist":"\(distanceBetweenCoordinates*0.000621371)", "avgSpeed":"\(avgSpeed*2.23)"])

            print("Places now: \(places.count) \n\(places)")
            
            
            
//            print("Average speed: \(avgSpeed/Double(locationCounter))")
            
            self.viewRideInfoBTN.hidden = false
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
    
    

///////////////////////////////////////////////////--------------------UPDATING LOCATIONS--------------------///////////////////////////////////////////////////
    
    
    func locationManager(manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        
        allLocations = locations
        
        speedArray.append(location.speed)
        
        myLocations.append(locations[0])
        
        
        if myLocations.count == 1 {
            
            var startRidePin:MKPointAnnotation = MKPointAnnotation()
            
            startRidePin.title = " "
            startRidePin.subtitle = " "
            
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
                    
                    startRidePin.title = title
                    startRidePin.subtitle = subTitle
                    
                    self.currentLocation.addAnnotation(startRidePin)
                    
                }
            })
        }
        
        myLocationsIndex++
        
        print("\(allLocations[allLocationsIndex].speed)")
        
        
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
            
            print("C1: \(c1) C2: \(c2)")
            
            
            from = CLLocation(latitude: c1.latitude, longitude: c1.longitude)
            to = CLLocation(latitude: c2.latitude, longitude: c2.longitude)
            
            distanceBetweenCoordinates += from.distanceFromLocation(to)
            
            print("Distance : \(distanceBetweenCoordinates)")

        }
        
        endDestination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        
        locationCounter++
        
        print("No of locations : \(locationCounter)")
        

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

