//
//  RideInfoViewController.swift
//  iRide
//
//  Created by Nihitha,Bhimireddy on 3/15/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import UIKit

class RideInfoViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var fromLBL: UILabel!
    
    @IBOutlet weak var toLBL: UILabel!

    @IBOutlet weak var distanceLBL: UILabel!
    
    @IBOutlet weak var speedLBL: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
//       @IBAction func logThisBTN(sender: AnyObject) {
//        let title = "iRide"
//        let message = "Your ride has been logged"
//        let okText = "OK"
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
//        alert.addAction(okayButton)
//        presentViewController(alert, animated: true, completion:nil)
//        
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        fromLBL.text = "\(places.last!["Start"]!)"
        
        toLBL.text = "\(places.last!["End"]!)"
        
        distanceLBL.text = String(format: "%1.2f miles", distanceBetweenCoordinates*0.000621371)
        
        speedLBL.text = String(format: "%1.2f mph", Double(places.last!["avgSpeed"]!)!)
        
        if Double(places.last!["rideTime"]!)! > 60 {
            time.text = String(format: "%2.0f min %2.0f sec", (Double(places.last!["rideTime"]!)!)/60, (Double(places.last!["rideTime"]!)!) - 60)
        }
        
        else if Double(places.last!["rideTime"]!)! > 3600 {
            time.text = String(format:"%2.0f hr", (Double(places.last!["rideTime"]!)!)/3600)
        }
        
        else {
            time.text = String(format: "%2.0f sec", Double(places.last!["rideTime"]!)!)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
