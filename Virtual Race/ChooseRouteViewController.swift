//
//  ChooseRouteViewController.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ChooseRouteViewController: UIViewController {
    
    var fetchedResultsController: NSFetchedResultsController!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var oppName = String()
    var oppAvatar = NSData()
    var oppID = String()
    
    var oneDayfromNow: NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
    }
    
    @IBAction func chooseRoute(sender: AnyObject) {
        
       /* let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let convertedDate = dateFormatter.stringFromDate(oneDayfromNow)
 */
        
        if oppID == NSUserDefaults.standardUserDefaults().objectForKey("myID") as? String {
            
            let startMatchAlert = UIAlertController(title: "Confirm the Start of a New Match", message: "you new match against yourself will start at midnight on \(oneDayfromNow)", preferredStyle: UIAlertControllerStyle.Alert)
            startMatchAlert.addAction(UIAlertAction(title: "Start the match!", style: .Default, handler: { (action: UIAlertAction!) in
                
                let newMatch = Match(startDate: self.oneDayfromNow, myID: self.oppID, context: (self.delegate.stack?.context)!)
                
                newMatch.myAvatar = self.oppAvatar
                newMatch.myName = NSUserDefaults.standardUserDefaults().objectForKey("fullName") as? String
                newMatch.finished = false
                newMatch.started = true
                
                self.delegate.stack?.save()
                
                let controller: ViewMatchViewController
                controller = self.storyboard!.instantiateViewControllerWithIdentifier("ViewMatchViewController") as! ViewMatchViewController
                self.presentViewController(controller, animated: false, completion: nil)
                
            }))
            
            startMatchAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction!) in
                
                print("cancel pushed")
            }))
            
            self.presentViewController(startMatchAlert, animated: true, completion: nil)
        } else {
            
            let startMatchAlert = UIAlertController(title: "Confirm the Start of a New Match", message: "you new match against \(self.oppName) will start at midnight on \(oneDayfromNow)", preferredStyle: UIAlertControllerStyle.Alert)
            startMatchAlert.addAction(UIAlertAction(title: "Start the match!", style: .Default, handler: { (action: UIAlertAction!) in
                
                let myID = NSUserDefaults.standardUserDefaults().objectForKey("myID") as? String!
                
                let newMatch = Match(startDate: self.oneDayfromNow, myID: myID!, context: (self.delegate.stack?.context)!)
                
                newMatch.myName = NSUserDefaults.standardUserDefaults().objectForKey("fullName") as! String
                newMatch.myAvatar = NSUserDefaults.standardUserDefaults().objectForKey("myAvatar") as! NSData
                newMatch.oppID = self.oppID
                newMatch.oppName = self.oppName
                newMatch.oppAvatar = self.oppAvatar
                newMatch.finished = false
                newMatch.started = false
                
                self.delegate.stack?.save()
                
                let controller: ViewMatchViewController
                controller = self.storyboard!.instantiateViewControllerWithIdentifier("ViewMatchViewController") as! ViewMatchViewController
                self.presentViewController(controller, animated: false, completion: nil)
                
                }))
            
            self.presentViewController(startMatchAlert, animated: true, completion: nil)
        }
        
    }
    
    /*
    let controller: MapViewController
    controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    
    controller.startDate = oneDayfromNow
    
    self.presentViewController(controller, animated: false, completion: nil)
 */
    
}