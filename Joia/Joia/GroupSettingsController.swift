//
//  GroupSettingsController.swift
//  Joia
//
//  Created by Josh Bodily on 11/20/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class GroupSettingsController : BaseController, UITextFieldDelegate {
  
  var originalName:String?
  @IBOutlet weak var locked: UISwitch!
  @IBOutlet weak var groupName: UITextField!
  @IBOutlet weak var invite: UITextField!
  
  @IBAction func toggleLocked(sender: AnyObject) {

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    guard let _ = GroupModel.getCurrentGroup() else {
      let alert = UIAlertController(title: "No group selected", message: "Please select a group", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        NSNotificationCenter.defaultCenter().postNotificationName("gotoGroups", object: nil)
      }
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
      return
    }
    
    if let name = GroupModel.getCurrentGroup()?.name {
      originalName = name
      groupName.text = name
    }
  }
  
  override func dismissKeyboard() {
    invite.resignFirstResponder()
    groupName.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    dismissKeyboard()
    submit(textField)
    return true
  }
  
  func textFieldDidEndEditing(textField:UITextField) {
    dismissKeyboard()
    submit(textField)
  }
  
  func submit(textField:UITextField) {
    if textField == invite {
      if let email = textField.text {
        GroupModel().invite(email)
      }
    } else if let name = originalName {
      if let currentName = textField.text where currentName != name {
        let group = GroupModel.getCurrentGroup()!
        originalName = currentName
        group.name = currentName
        GroupModel().update(group)
      }
    }
  }
}