//
//  RegisterController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class RegisterController : BaseController, UITextFieldDelegate {
  
  enum GroupAction {
    case Join
    case Create
  }
  
  var action:GroupAction!

  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var register: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func dismissKeyboard() {
    password.resignFirstResponder()
    email.resignFirstResponder()
    username.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification: NSNotification) {
    register.isHidden = true
    super.keyboardWillShow(notification: notification)
    height.constant = 0
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  override func keyboardWillHide(notification:NSNotification) {
    register.isHidden = false
    super.keyboardWillHide(notification: notification)
    height.constant = 200
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    })
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    return true
  }
  
  func updateButtons(enabled:Bool) {
    register.isEnabled = enabled;
    register.alpha = enabled ? 1.0 : 0.5;
  }
  
  @IBAction func submit(_ sender: AnyObject) {
    updateButtons(enabled: false);
    let model = UserModel();
    model.success { (message:String?, user:AnyObject?) -> Void in
      UserModel.setCurrentUser(user: user as? User)
      let groupModel = GroupModel()
      groupModel.success { (message:String?, group:AnyObject?) -> Void in
        GroupModel.setCurrentGroup(group: group as? Group)
        switch self.action! {
        case .Join:
          self.performSegue(withIdentifier: "gotoCompose", sender: self)
        case .Create:
          self.performSegue(withIdentifier: "gotoInvite", sender: self)
        }
      }
      groupModel.error { (message:String?) -> Void in
        let messageUnwrapped = message ?? "Could not join group at this time.  Please try again later."
        self.showAlert(title: "Oops", message: messageUnwrapped)
        self.updateButtons(enabled: true);
      }
      groupModel.join(user: user as! User)
    }
    model.error { (message:String?) -> Void in
      let messageUnwrapped = message ?? "Something went wrong."
      self.showAlert(title: "Oops", message: messageUnwrapped)
      self.updateButtons(enabled: true);
    }
    model.create(username: username.text!, email: email.text!, password: password.text!)
  }
}
