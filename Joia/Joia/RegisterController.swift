//
//  RegisterController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class RegisterController : BaseController, UITextViewDelegate {
  
  enum GroupAction {
    case Join
    case Create
  }
  
  var action:GroupAction!

  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func dismissKeyboard() {
    password.resignFirstResponder()
    email.resignFirstResponder()
    username.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == username) {
      email.becomeFirstResponder()
    }
    if (textField == email) {
      password.becomeFirstResponder()
    }
    if (textField == password) {
      submit(self)
    }
    return false
  }
  
  @IBAction func submit(sender: AnyObject) {
    let model = UserModel();
    model.success { (message:String?, user:AnyObject?) -> Void in
      UserModel.setCurrentUser(user as! User)
      let groupModel = GroupModel()
      groupModel.success { (message:String?, group:AnyObject?) -> Void in
        GroupModel.setCurrentGroup(group as! Group)
        switch self.action! {
        case .Join:
          self.performSegueWithIdentifier("gotoCompose", sender: self)
        case .Create:
          self.performSegueWithIdentifier("gotoInvite", sender: self)
        }
      }
      groupModel.error { (message:String?) -> Void in
        let messageUnwrapped = message ?? "Could not join group at this time.  Please try again later."
        self.showAlert("Oops", message: messageUnwrapped)
      }
      groupModel.join(user as! User)
    }
    model.error { (message:String?) -> Void in
      let messageUnwrapped = message ?? "Something went wrong."
      self.showAlert("Oops", message: messageUnwrapped)
    }
    model.create(username.text!, email: email.text!, password: password.text!)
  }
}