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
      userModel.success(callback: { (_, model) -> Void in
        let groupModel = GroupModel()
        groupModel.success { (_, model:AnyObject?) -> Void in
          let groups = model as! Array<Group>
          if let currentGroup = GroupModel.getCurrentGroup() {
            if let _ = groups.index(where: { $0.guid == currentGroup.guid }) {
              
            } else {
              GroupModel.setCurrentGroup(group: groups.first)
            }
          } else {
            GroupModel.setCurrentGroup(group: groups.first)
          }
          self.performSegue(withIdentifier: "gotoCompose", sender: self)
        }
        groupModel.getAll(user: user)
      })
      userModel.get(user: user)
    }
  }
  
  @IBAction func environmentSelector(_ sender: AnyObject) {
    let rows = ["Production", "Staging", "Dev (Charles)", "Dev"]
    ActionSheetMultipleStringPicker.show(withTitle: "Select Environment", rows: [rows], initialSelection: [0], doneBlock: {_,values,indices in
      // TODO: Fix me!!
//      switch indices[0] as! String {
//      case "Production": Config.baseUrl = PRODUCTION_URL
//      case "Staging":  Config.baseUrl = STAGING_URL
//      case "Dev (Charles)":  Config.baseUrl = CHARLES_URL
//      case "Dev":  Config.baseUrl = LOCAL_URL
//      default:
//        print("Invalid Selection")
//      }
//      let defaults = UserDefaults.standard;
//      defaults.set(Config.baseUrl, forKey: "environment")
    }, cancel: nil, origin: self.view)
  }
  
  @IBAction func signInPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoLogin", sender: self)
  }
  
  @IBAction func registerPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoJoinOrCreate", sender: self)
  }
}
