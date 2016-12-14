//
//  AppDelegate.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    if let user = UserModel.currentUser {
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

