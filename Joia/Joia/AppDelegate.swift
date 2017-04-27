//
//  AppDelegate.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSURLSessionDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Set up the stored default environment
    let defaults = NSUserDefaults.standardUserDefaults()
    if let storedEnvironment = defaults.objectForKey("environment") as? String {
      Config.baseUrl = storedEnvironment
    }
    
    UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name:"OpenSans", size:12)!, NSForegroundColorAttributeName: UIColor.grayColor()], forState: .Normal)
    UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name:"OpenSans", size:12)!, NSForegroundColorAttributeName: APP_COLOR], forState: .Selected)
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    if let user = UserModel.getCurrentUser() {
      UserModel().updatePushToken(user, token: deviceToken)
    } else {
      // store for later updating
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setObject(deviceToken.toHexString(), forKey: "push_token")
    }
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    print("Failed to register for remote notifications \(error.localizedDescription)")
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {

  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
    
    let calendar = NSCalendar.currentCalendar()
    let components = NSDateComponents()
    components.hour = 12 + 7
    components.minute = 0
    
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    let localNotification = UILocalNotification()
    localNotification.fireDate = calendar.dateFromComponents(components)
    localNotification.alertBody = "Did you remember to write in your Joia journal today?"
    localNotification.timeZone = NSTimeZone.localTimeZone()
    localNotification.repeatInterval = NSCalendarUnit.Day
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.category = "Write" //Optional
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
  }
  
  func applicationWillTerminate(application: UIApplication) {
    
  }
}

