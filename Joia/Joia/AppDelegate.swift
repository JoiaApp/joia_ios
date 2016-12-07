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
  
  func applicationDidBecomeActive(application: UIApplication) {
    let types:UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert]
    let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    
  }
}

