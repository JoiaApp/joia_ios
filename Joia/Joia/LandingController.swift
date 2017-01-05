//
//  LandingController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class LandingController : UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // check if already logged in
    if let user = UserModel.getCurrentUser() {
      let userModel = UserModel()
      userModel.success({ (_, model) -> Void in
        let groupModel = GroupModel()
        groupModel.success { (_, model:AnyObject?) -> Void in
          let groups = model as! Array<Group>
          if let currentGroup = GroupModel.getCurrentGroup() {
            if let _ = groups.indexOf({ $0.guid == currentGroup.guid }) {
              
            } else {
              GroupModel.setCurrentGroup(groups.first)
            }
          } else {
            GroupModel.setCurrentGroup(groups.first)
          }
          self.performSegueWithIdentifier("gotoCompose", sender: self)
        }
        groupModel.getAll(user)
      })
      userModel.get(user)
    }
  }
  
  @IBAction func environmentSelector(sender: AnyObject) {
    let rows = ["Production", "Staging", "Dev (Charles)", "Dev"]
    ActionSheetMultipleStringPicker.showPickerWithTitle("Select Environment", rows: [rows], initialSelection: [0], doneBlock: {_,values,indices in
      switch indices[0] as! String {
        case "Production": Config.baseUrl = PRODUCTION_URL
        case "Staging":  Config.baseUrl = STAGING_URL
        case "Dev (Charles)":  Config.baseUrl = CHARLES_URL
        case "Dev":  Config.baseUrl = LOCAL_URL
        default:
          print("Invalid Selection")
      }
      let defaults = NSUserDefaults.standardUserDefaults()
      defaults.setObject(Config.baseUrl, forKey: "environment")
    }, cancelBlock: nil, origin: self.view)
  }
  
  @IBAction func signInPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoLogin", sender: self)
  }
  
  @IBAction func registerPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoJoinOrCreate", sender: self)
  }
}
