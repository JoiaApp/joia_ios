//
//  LandingController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

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
  
  @IBAction func signInPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoLogin", sender: self)
  }
  
  @IBAction func registerPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoJoinOrCreate", sender: self)
  }
}
