//
//  StartMatchViewController.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation
import UIKit




class StartMatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableView: UITableView!
    
    @IBAction func returnButton(sender: AnyObject) {
        let controller: LoginWebViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginWebViewController") as! LoginWebViewController
        self.presentViewController(controller, animated: false, completion: nil)
    }
    
    var friendList = [[String:AnyObject]]()
    var imageList = [NSData]()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(friendList.count)
        return friendList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")!
        
        let row = friendList[indexPath.row]
        
        guard let user = row["user"] as? [String:AnyObject] else {
            print("could not get user")
            return cell
        }
    
        
        guard let avatar = user["avatar"] as? String else {
            print("could not get avatar")
            return cell
        }
        
        guard let name = user["displayName"] as? String else {
            print("could not get name")
            return cell
        }
        
        
        let avatarURL = NSURL(string: avatar)
        
        let avatarImage = NSData(contentsOfURL: (avatarURL)!)
        
        self.imageList.insert(avatarImage!, atIndex: indexPath.row)
        
        cell.imageView!.image = UIImage(data: avatarImage!)
        
        cell.textLabel?.text = name
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let row = friendList[indexPath.row]
        
        guard let user = row["user"] as? [String:AnyObject] else {
            print("could not get user")
            return
        }
        
        guard let avatar = user["avatar"] as? String else {
            print("could not get avatar")
            return
        }
        
        guard let name = user["displayName"] as? String else {
            print("could not get name")
            return
        }
        
        
        guard let encodedID = user["encodedId"] as? String else {
            print("no encoded ID")
            return
        }
        
        
        let controller: ChooseRouteViewController
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("ChooseRouteViewController") as! ChooseRouteViewController
        
        controller.oppName = name
        controller.oppAvatar = self.imageList[indexPath.row]
        controller.oppID = encodedID
        
        self.presentViewController(controller, animated: false, completion: nil)
        
        
    }

    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        let friends = retrieveFBFriends()
        friends.getFriends() { (friendsList) in
            
            self.friendList = friendsList
            
            let avatar = NSUserDefaults.standardUserDefaults().URLForKey("avatar")
            let encodedID = NSUserDefaults.standardUserDefaults().objectForKey("myID") as! String
            
            let avatar2 = String(avatar!)
            
            self.friendList.insert((["user": ["avatar": avatar2, "displayName" : "Start a new race with yourself", "encodedId": encodedID]]), atIndex: 0)
            
            performUIUpdatesOnMain{
            self.TableView.reloadData()
            }
            
        }
    }

    
    
    
}