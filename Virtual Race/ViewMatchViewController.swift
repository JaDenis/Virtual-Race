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




class ViewMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fetchedResultsController: NSFetchedResultsController!
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var raceList = [Match]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return raceList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        
        
        
        let avatarImage = raceList[indexPath.row].myAvatar
        
        
        cell.imageView!.image = UIImage(data: avatarImage!)
        cell.textLabel?.text = raceList[indexPath.row].myName

        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = raceList[indexPath.row] 
        
        
        let controller: MapViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        controller.match = row
        
        self.presentViewController(controller, animated: false, completion: nil)

        
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        let fr = NSFetchRequest(entityName: "Match")
        fr.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: (delegate.stack?.context)!, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("could not perform fetch")
        }
        
        for i in fetchedResultsController.fetchedObjects! {
            let managed = i as? NSManagedObject
            let managed2 = managed as? Match
            raceList.append(managed2!)
        }
    }


}