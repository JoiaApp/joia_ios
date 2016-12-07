//
//  LoginController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class LoginController : BaseController, UITextFieldDelegate {
  
  @IBOutlet weak var height: NSLayoutConstraint!
  var loginModel:UserModel!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var submit: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loginModel = UserModel()
    loginModel.success { (msg:String?, model:AnyObject?) -> Void in
      self.loginDidSucceed()
    }
    self.loginModel.error { (data:String?) -> Void in
      self.showAlert("Oops...", message: "Username or password incorrect.")
    }
  }
  
  override func dismissKeyboard() {
    email.resignFirstResponder()
    password.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    super.keyboardWillShow(notification)
    height.constant = 0
    UIView.animateWithDuration(0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
  
  override func keyboardWillHide(notification:NSNotification) {
    super.keyboardWillHide(notification)
    height.constant = 200
    UIView.animateWithDuration(0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == email) {
      password.becomeFirstResponder()
    }
    if (textField == password) {
      loginModel.login(email.text!, password: password.text!)
    }
    return false
  }
  
  func loginDidSucceed() {
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
    groupModel.error { (msg:String?) -> Void in
      self.showAlert("Oops...", message: "Something went wrong.")
    }
    groupModel.getAll(UserModel.getCurrentUser()!)
  }
  
  @IBAction func submit(sender: UIButton) {
    loginModel.login(email.text!, password: password.text!)
  }
}

