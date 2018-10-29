//
//  GroupSettingsController.swift
//  Joia
//
//  Created by Josh Bodily on 11/20/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class GroupSettingsController : BaseController, UITextFieldDelegate {
  
  var originalName:String?
  @IBOutlet weak var locked: UISwitch!
  @IBOutlet weak var groupName: UITextField!
  @IBOutlet weak var invite: UITextField!
  @IBOutlet weak var groupId: UILabel!
  
  @IBAction func send(_ sender: AnyObject) {
    if let email = invite.text {
      if let user = UserModel.getCurrentUser() {
        GroupModel().invite(email: email, isMention: false, user_id: user.id)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    groupId.text = "Group ID: "
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let _ = GroupModel.getCurrentGroup() else {
      let alert = UIAlertController(title: "No group selected", message: "Please select a group", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        self.tabBarController?.selectedIndex = GROUPS_INDEX
      }
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    if let name = GroupModel.getCurrentGroup()?.name {
      originalName = name
      groupName.text = name
    }
    if let guid = GroupModel.getCurrentGroup()?.guid {
      groupId.text = "Groud ID: \(guid)"
    }
  }
  
  override func dismissKeyboard() {
    invite.resignFirstResponder()
    groupName.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    submit(textField: textField)
    return true
  }
  
  func textFieldDidEndEditing(_ textField:UITextField) {
    dismissKeyboard()
    submit(textField: textField)
  }
  
  func submit(textField:UITextField) {
    if textField == invite {
      if let email = textField.text {
        let model = GroupModel()
        model.success(callback: { (_, model) -> Void in
          self.showAlert(title: "Sent", message: "Invite sent to \(email)")
        })
        model.invite(email: email, isMention: true, user_id: UserModel.getCurrentUser()!.id)
      }
    } else if let name = originalName {
      if let currentName = textField.text, currentName != name {
        let group = GroupModel.getCurrentGroup()!
        originalName = currentName
        group.name = currentName
        let model = GroupModel()
        model.success(callback: { (_, model) -> Void in
          self.showAlert(title: "Updated", message: "Group name updated to \(currentName)")
        })
        model.update(group: group)
      }
    }
  }
}
