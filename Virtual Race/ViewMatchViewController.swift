//
//  ViewMatchViewController.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit




class ViewMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func returnButton(sender: AnyObject) {
        let controller: LoginWebViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginWebViewController") as! LoginWebViewController
        self.presentViewController(controller, animated: false, completion: nil)

    }
    

    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var raceList = [Match]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return raceList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let extraInfo = MapViewController()
        
        
        
        var avatarImage = NSData()
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        
        let row = raceList[indexPath.row]
        
        let raceLocation = extraInfo.chooseRaceCourse(row.raceLocation!)!
        
        
        if row.oppAvatar == nil {
        avatarImage = row.myAvatar!
        cell.textLabel!.text = "Racing from \(raceLocation.startingTitle) to \(raceLocation.endingTitle)"
        } else {
        avatarImage = row.oppAvatar!
        cell.textLabel?.text = "Racing \(row.oppName!) from \(raceLocation.startingTitle) to \(raceLocation.endingTitle)"
        }
        
        
        cell.imageView!.image = UIImage(data: avatarImage)
        
        
        
        if row.finished == true && row.oppID == nil {
            
            cell.detailTextLabel?.text = "Status: The race is over! You started on \(formatDate(row.startDate!)) and finished on \(row.finishDate!)"
            
        } else if row.finished == true && row.winner == "N/A" {
            
            cell.textLabel?.text = "\(row.oppName!) has declined this particular race"
            cell.detailTextLabel?.text = "The race was from \(raceLocation.startingTitle) to \(raceLocation.endingTitle)"
            
        } else if row.finished == true && row.oppID != nil {
            
            cell.detailTextLabel?.text = "Status: The race is over! \(row.winner!) finished 1st on \(row.finishDate!)"
        
        } else if row.started == true  {
            
        cell.detailTextLabel!.text = "Status: Race start date: \(formatDate(row.startDate!))"
            
        } else {
            
            print("race status is not started")
            
            let defaultContainer = CKContainer.defaultContainer()
            let publicDB = defaultContainer.publicCloudDatabase
            publicDB.fetchRecordWithID(row.recordID!) { (record, error) -> Void in
                guard let record = record else {
                    print("Error fetching record: ", error)
                    return
                }
                
                if record.objectForKey("started") as? String == "false" {
                    print("server shows the race has still not started")
                    performUIUpdatesOnMain{
                    cell.detailTextLabel!.text = "Status: Waiting for your race request to be accepted"
                    }
                } else {
                    row.started = true
                    row.startDate = record.objectForKey("startDate") as? NSDate
                    performUIUpdatesOnMain{
                    cell.detailTextLabel!.text = "Status: Race started on \(formatDate(row.startDate!))"
                    }
                }
            }
            
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = raceList[indexPath.row] 
        
        if row.started == true {
        
        let controller: MapViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        controller.match = row
        
        self.presentViewController(controller, animated: false, completion: nil)
            
        }
        
    }
    
    var deleteMatchIndexPath: NSIndexPath? = nil
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteMatchIndexPath = indexPath
            let matchToDelete = raceList[indexPath.row]
            confirmDelete(matchToDelete)
        }
    }
    
    func confirmDelete(match: Match) {
        let alert = UIAlertController(title: "Hide Race Request", message: "Are you sure you want to permanently hide this request?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
    
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteMatchIndexPath {
            tableView.beginUpdates()
            
            delegate.stack?.context.deleteObject(raceList[indexPath.row])
            
            raceList.removeAtIndex(indexPath.row)
            
            
            delegate.stack?.save()
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            deleteMatchIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteMatchIndexPath = nil
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        print("view races loaded")
        
        self.raceList.removeAll()
        
        
        let fr = NSFetchRequest(entityName: "Match")
        fr.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (delegate.stack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("could not perform fetch")
        }
        
        for i in fetchedResultsController.fetchedObjects! {
            let t = i as? Match
            
            if t!.started == false {
                let defaultContainer = CKContainer.defaultContainer()
                let publicDB = defaultContainer.publicCloudDatabase
                publicDB.fetchRecordWithID(t!.recordID!) { (record, error) -> Void in
                    
                    
                    guard error == nil else {
                        return
                    }
                    
                    guard let record = record else {
                        print("the race has been rejected")
                        return
                    }
                    
                    if record.objectForKey("started") as? String == "true" {
                        t!.started = true
                    }
                    
                    if record.objectForKey("rejected") as! String == "true" {
                        print("race has been rejected")
                        t!.finished = true
                        t!.winner = "N/A"
                    }
                }
            }
            
            if t?.started == true && t?.recordID != nil {
            let defaultContainer = CKContainer.defaultContainer()
            let publicDB = defaultContainer.publicCloudDatabase
            publicDB.fetchRecordWithID(t!.recordID!) { (record, error) -> Void in
                guard let record = record else {
                    print("Error fetching record: ", error)
                    return
                }
                if record.objectForKey("finished") as? String == "true" {
                    t!.finished = true
                    t!.winner = record.objectForKey("winner") as? String
                    t!.finishDate = record.objectForKey("finishDate") as? String
                }
                }
            }
            
            raceList.append(t!)
            
        }
        
            self.tableView.reloadData()
    }

}