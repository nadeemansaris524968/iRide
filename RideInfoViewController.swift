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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
