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
  
  @IBOutlet weak var register: UIButton!
  @IBOutlet weak var login: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    login.isEnabled = false
    login.alpha = 0.5
    register.isEnabled = false
    register.alpha = 0.5
    
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
    } else {
      login.isEnabled = true
      login.alpha = 1.0
      register.isEnabled = true
      register.alpha = 1.0
    }
  }
  
  @IBAction func signInPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoLogin", sender: self)
  }
  
  @IBAction func registerPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoJoinOrCreate", sender: self)
  }
}
