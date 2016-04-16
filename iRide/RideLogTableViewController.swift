//
//  RideLogTableViewController.swift
//  iRide
//
//  Created by Ansari,Nadeem on 4/9/16.
//  Copyright © 2016 Generation Of Miracles. All rights reserved.
//

import UIKit
import CoreData

var activePlace = -1

var places = [Dictionary<String, String>()]
var fromLoc: String = " "
var toLoc: String = " "
var distance: String = " "
var timeTaken: String = " "
var avgspeed: String = " "
var date: String = " "
var results:AnyObject!
class RideLogTableViewController: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let request = NSFetchRequest(entityName: "RideLog")
        
        request.returnsObjectsAsFaults = false
        
        let results = try? context.executeFetchRequest(request)
        
        if results!.count > 0 {
            
            for result: AnyObject in results! {
                
                fromLoc = result.valueForKey("from") as! String
                toLoc = result.valueForKey("to") as! String
                distance = result.valueForKey("distance") as! String
                timeTaken = result.valueForKey("time") as! String
                avgspeed = result.valueForKey("avgspeed") as! String
                date = result.valueForKey("date") as! String
                
               
                
                
            }
            
            print("\(fromLoc + " " + toLoc + " " + distance + " " + timeTaken + " " + avgspeed + " " + date)")
           
            
        } else {
            
            print("No results")
            
        }
        

        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        //cell.textLabel?.text = rides[indexPath.row].startLocation
        //cell.detailTextLabel?.text = rides[indexPath.row].endLocation

        cell.textLabel?.text = "\(fromLoc + " - " + toLoc)"
        cell.detailTextLabel?.text = date
        
        return cell
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlace = indexPath.row
        return indexPath
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
