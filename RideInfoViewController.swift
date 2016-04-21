//
//  RideInfoViewController.swift
//  iRide
//
//  Created by Nihitha,Bhimireddy on 3/15/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import UIKit
import CoreData

class RideInfoViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
//    @IBOutlet weak var fromLBL: UILabel!
    
    @IBOutlet weak var fromLBL: UITextView!
    
//    @IBOutlet weak var toLBL: UILabel!
    
    
    @IBOutlet weak var toLBL: UITextView!

    @IBOutlet weak var distanceLBL: UILabel!
    
    @IBOutlet weak var speedLBL: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var dateLBL: UILabel!
    
    @IBOutlet weak var logThisBtn: UIButton!
    
    @IBAction func logThisBtn(sender: UIButton) {
        
        let uiAlertController:UIAlertController = UIAlertController(title: "Ride Info",
            message: "Your ride has been logged!", preferredStyle: UIAlertControllerStyle.Alert)
        
        uiAlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel,
            handler:{(action:UIAlertAction)->Void in  }))
        self.presentViewController(uiAlertController, animated: true, completion: nil)
        
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        let rideLog = NSEntityDescription.insertNewObjectForEntityForName("RideLog", inManagedObjectContext: context)
        
        
        rideLog.setValue(fromLBL.text, forKey: "from")
        rideLog.setValue(toLBL.text, forKey: "to")

        rideLog.setValue(distanceLBL.text, forKey: "distance")
        rideLog.setValue(time.text, forKey: "time")
        rideLog.setValue(speedLBL.text, forKey: "avgspeed")
        rideLog.setValue(dateLBL.text, forKey: "date")
        
        do {
            try context.save()
        } catch  {
            // Handle error stored in *error* here
        }
        

    }
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
        
        if activePlace == -1 {
            fromLBL.text = "\(places.last!["Start"]!)"
            toLBL.text = "\(places.last!["End"]!)"
            
            dateLBL.text = "21 April 2016"
            
            distanceLBL.text = String(format: "%1.2f miles", Double(places.last!["dist"]!)!)
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
            
            if logThisBtn.hidden {
                logThisBtn.hidden = false
            }
            
        }
        
        else {
            
                    fromLBL.text = "\(places[activePlace]["Start"]!)"
            
                    toLBL.text = "\(places[activePlace]["End"]!)"
            
                    distanceLBL.text = String(format: "%1.2f miles", Double(places[activePlace]["dist"]!)!)
            
                    speedLBL.text = String(format: "%1.2f mph", Double(places[activePlace]["avgSpeed"]!)!)
            
                    dateLBL.text = "21 April 2016"
            
                    if Double(places.last!["rideTime"]!)! > 60 {
                        time.text = String(format: "%2.0f min %2.0f sec", (Double(places[activePlace]["rideTime"]!)!)/60, (Double(places[activePlace]["rideTime"]!)!) - 60)
                    }
            
                    else if Double(places.last!["rideTime"]!)! > 3600 {
                        time.text = String(format:"%2.0f hr", (Double(places[activePlace]["rideTime"]!)!)/3600)
                    }
                    
                    else {
                        time.text = String(format: "%2.0f sec", Double(places[activePlace]["rideTime"]!)!)
                    }
            
//            if logThisBtn.hidden {
//                logThisBtn.hidden = false
//            }
            
            logThisBtn.hidden = true
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
