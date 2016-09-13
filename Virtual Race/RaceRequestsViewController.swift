//
//  RaceRequestsViewController.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/9/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


class RaceRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func returnButton(sender: AnyObject) {
        let controller: LoginWebViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginWebViewController") as! LoginWebViewController
        self.presentViewController(controller, animated: false, completion: nil)
    }
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var requestList = [CKRecord]()
    var friendList = [[String:AnyObject]]()
    var imageList = [NSData]()
    var oppName = String()

    var oneDayfromNow: NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: 1, toDate: NSDate(), options: [])!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return requestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let extraInfo = MapViewController()
     
        var oppAvatar = String()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        
        
        let row = requestList[indexPath.row]
        
        let raceLocation = extraInfo.chooseRaceCourse((row.objectForKey("raceLocation") as? String)!)
        
        
        for i in friendList {
            
            guard let user = i["user"] as? [String:AnyObject] else {
                print("could not get user")
                return cell
            }

            
            guard let encodedID = user["encodedId"] as? String else {
                print("no encoded ID")
                return cell
            }
            
            guard let name = user["displayName"] as? String else {
                print("could not get name")
                return cell
            }
            
            
            if encodedID == row.objectForKey("myID") as! String {
                print("found a match with my friends!")
                guard let avatar = user["avatar"] as? String else {
                    print("no opp avatar")
                    return cell
                }
                
               self.oppName = name
               oppAvatar = avatar
                
                cell.textLabel?.text = "\(name) has challenged you to a race"
                
                cell.detailTextLabel!.text = "The race would start in \(raceLocation?.startingTitle) and end in \(raceLocation?.endingTitle)"
                
                let avatarURL = NSURL(string: oppAvatar)
                
                let avatarImage = NSData(contentsOfURL: (avatarURL)!)
                
                self.imageList.insert(avatarImage!, atIndex: indexPath.row)
                
                cell.imageView?.image = UIImage(data: avatarImage!)
            }
            
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = requestList[indexPath.row]
        let myID = NSUserDefaults.standardUserDefaults().objectForKey("myID") as? String!
       
        let defaultContainer = CKContainer.defaultContainer()
        let publicDB = defaultContainer.publicCloudDatabase

        
        let startMatchAlert = UIAlertController(title: "Confirm the Start of a New Match", message: "your new match against \(self.oppName) will start at midnight on \(formatDate(oneDayfromNow))", preferredStyle: UIAlertControllerStyle.Alert)
        
        startMatchAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: {(action: UIAlertAction!) in
            
            for i in self.friendList {
                
                guard let user = i["user"] as? [String:AnyObject] else {
                    print("could not get user")
                    return
                }
                
                
                guard let encodedID = user["encodedId"] as? String else {
                    print("no encoded ID")
                    return
                }
                
                guard let name = user["displayName"] as? String else {
                    print("could not get name")
                    return
                }

            if encodedID == row.objectForKey("myID") as? String {
                
                let newMatch = Match(startDate: self.oneDayfromNow, myID: myID! , context: (self.delegate.stack?.context)!)
                newMatch.myName = NSUserDefaults.standardUserDefaults().objectForKey("fullName") as? String
                newMatch.myAvatar = NSUserDefaults.standardUserDefaults().objectForKey("myAvatar") as? NSData
                newMatch.oppID = encodedID
                newMatch.oppName = name
                newMatch.oppAvatar = self.imageList[indexPath.row]
                newMatch.finished = false
                newMatch.started = true
                newMatch.recordID = row.recordID
                newMatch.raceLocation = row.objectForKey("raceLocation") as? String
                

                row.setObject("true", forKey: "started")
                row.setObject(self.oneDayfromNow, forKey: "startDate")
                
                publicDB.saveRecord(row) { (record, error) -> Void in
                    guard let record = record else {
                        print("Error saving record: ", error)
                        return
                    }
                    print("Successfully saved record: ", record)
                }

                self.delegate.stack?.save()
                
                let controller: ViewMatchViewController
                controller = self.storyboard!.instantiateViewControllerWithIdentifier("ViewMatchViewController") as! ViewMatchViewController
                self.presentViewController(controller, animated: false, completion: nil)
                
                
                }
            }
            
        }))

        startMatchAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction!) in
            
            print("cancel pushed")
        }))
        
        /*
        startMatchAlert.addAction(UIAlertAction(title: "Reject", style: .Default, handler: {(action: UIAlertAction!) in
            publicDB.deleteRecordWithID(row.recordID) { (recordID, error) in
                NSLog("OK or \(error)")
                print("\(recordID) successfully deleted")
                
                self.friendList.removeAtIndex(indexPath.row)
                
                self.tableView.reloadData()
            }
            
            }))
 */

        self.presentViewController(startMatchAlert, animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        
        let friends = retrieveFBFriends()
        friends.getFriends() { (friendsList, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                friends.getFriends() { (friendsList, error) in
                    self.friendList = friendsList!
                }
                return
            }

            
            self.friendList = friendsList!
            
            let defaultContainer = CKContainer.defaultContainer()
            let publicDB = defaultContainer.publicCloudDatabase
            let predicate1 = NSPredicate(format: "%K == %@", "oppID", (NSUserDefaults.standardUserDefaults().objectForKey("myID") as? String!)!)
            let predicate2 = NSPredicate(format: "%K == %@", "started", "false")
             let andPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [predicate1, predicate2])
            let query = CKQuery(recordType: "match", predicate: andPredicate)
            
            publicDB.performQuery(query, inZoneWithID: nil) {
                (records, error) -> Void in
                guard let records = records else {
                    print("Error querying records: ", error)
                    return
                }
                
                self.requestList = records
                
            }
            performUIUpdatesOnMain{
                self.tableView.reloadData()
            }
        }

        }
        
        
}