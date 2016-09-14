//
//  RetrieveFBFriends.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import Foundation


class retrieveFBFriends {
    
    func getFriends(completionHandler: (friendList: [[String:AnyObject]]?, error: String?) -> Void ) {
        
        print("get friends")
        
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("Access Token") as? String
        
        let url = "https://api.fitbit.com/1/user/-/friends.json"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        processRequest(request) { (result, error) in
            
            
            if error == "Your Udacity post request returned a status code other than 2xx! Optional(401)" {
                print("need refresh token")
                completionHandler(friendList: nil, error: "Need Refresh Token")
            }
 
            
            guard let results = result else {
                return
            }
            
            guard let friends = results["friends"] as? [[String:AnyObject]] else {
                print("no friends list")
                return
            }

            
            completionHandler(friendList: friends, error: nil)
        }
    }
    
    
    
}