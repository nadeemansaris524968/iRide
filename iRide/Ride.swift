//
//  Ride.swift
//  iRide
//
//  Created by Ansari,Nadeem on 4/5/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import UIKit

class Ride {
    
    var startLocation:String!
    var endLocation:String!
    var pausedLocation:[String]!
        
    init (StartLocation:String, EndLocation:String) {
        startLocation = StartLocation
        endLocation = EndLocation
        //pausedLocation = PausedLocations
    }
    
    func addStartLocation (startLocation:String) {
        self.startLocation = startLocation
    }
    
    func addEndLocation (endLocation:String) {
        self.endLocation = endLocation
    }
    
    
}
