//
//  RetrieveFBFriends.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation


class retrieveFBFriends {
    
    func getFriends(completionHanlder: (friendList: [[String:AnyObject]]) -> Void ) {
        
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("Access Token") as? String
        
        let url = "https://api.fitbit.com/1/user/-/friends.json"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        processRequest(request) { (result, error) in
            
            guard let friends = result["friends"] as? [[String:AnyObject]] else {
                print("no friends list")
                return
            }
            
            
            
         //   print(friends)
            
            completionHanlder(friendList: friends)
        }
    }
    
    
    
}