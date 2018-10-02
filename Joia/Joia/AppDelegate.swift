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
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate {
  
  var window: UIWindow?
  
  private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    // Set up the stored default environment
    let defaults = UserDefaults.standard
    if let storedEnvironment = defaults.object(forKey: "environment") as? String {
      Config.baseUrl = storedEnvironment
    }
    
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name:"OpenSans", size:12)!, NSAttributedStringKey.foregroundColor: UIColor.gray], for: .normal)
    // TODO: Fix me!
//    UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name:"OpenSans", size:12)!, NSForegroundColorAttributeName: APP_COLOR], NSAttributedStringKey.foregroundColorNSAttributedStringKey.font, .selected)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    if let user = UserModel.getCurrentUser() {
      UserModel().updatePushToken(user: user, token: deviceToken)
    } else {
      // store for later updating
      let defaults = UserDefaults.standard
      defaults.set(deviceToken.toHexString(), forKey: "push_token")
    }
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register for remote notifications \(error.localizedDescription)")
  }
  
  func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
    UIApplication.shared.registerUserNotificationSettings(settings)
    UIApplication.shared.registerForRemoteNotifications()
    
    let calendar = Calendar.current;
    let components = DateComponents.init(calendar: calendar, timeZone: TimeZone.current, hour: 12 + 7)
    
    UIApplication.shared.cancelAllLocalNotifications()
    let localNotification = UILocalNotification()
    localNotification.fireDate = calendar.date(from: components)
    localNotification.alertBody = "Did you remember to write in your Joia journal today?"
    localNotification.timeZone = NSTimeZone.local
    localNotification.repeatInterval = NSCalendar.Unit.day
    localNotification.soundName = UILocalNotificationDefaultSoundName
    localNotification.category = "Write" //Optional

    UIApplication.shared.scheduleLocalNotification(localNotification)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    
  }
}

