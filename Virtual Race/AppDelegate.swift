//
//  AppDelegate.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/7/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let stack = CoreDataStack(modelName: "Model")
    
    func preloadData() {
        
        do{
            try stack!.dropAllData()
            print("data deleted")
        }catch{
            print("Error droping all objects in DB")
        }
    }

    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
       
        
  //      NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Access Token")
    //    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "Refresh Token")
      //  preloadData()

        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.blueColor()
       // UINavigationBar.appearance().barTintColor = UIColor.redColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().clipsToBounds = false
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    


    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
     
        NSNotificationCenter.defaultCenter().postNotificationName(kCloseSafariViewControllerNotification, object: url)
   
     /*
        let urlAuthorizationCode = String(url)
        
        let findStartingIndex = urlAuthorizationCode.rangeOfString("=")
        let startingIndex = findStartingIndex?.endIndex
        let modifiedURLAuthorizationCode = urlAuthorizationCode.substringFromIndex(startingIndex!)
        let findEndingIndex = modifiedURLAuthorizationCode.rangeOfString("&")
        let endingIndex = findEndingIndex?.startIndex
        let authorizationCode = modifiedURLAuthorizationCode.substringToIndex(endingIndex!)
        
        
        NSUserDefaults.standardUserDefaults().setObject(authorizationCode, forKey: "Access Token")

            */
 
        return true

 
    }
}

