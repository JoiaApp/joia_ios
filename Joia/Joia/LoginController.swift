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
  @IBOutlet weak var forgot: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    submit.isEnabled = false
    submit.alpha = 0.5
    
    forgot.isEnabled = false
    forgot.alpha = 0.5
    
    loginModel = UserModel()
    loginModel.success { (msg:String?, model:AnyObject?) -> Void in
      let defaults = UserDefaults.standard
      if let pushToken = defaults.string(forKey: "push_token") {
        UserModel().updatePushToken(user: UserModel.getCurrentUser()!, token: pushToken)
      }
      self.updateButtons();
    }
    self.loginModel.error { (data:String?) -> Void in
      self.showAlert(title: "Oops...", message: "Username or password incorrect.");
      self.updateButtons();
    }
  }
  
  override func dismissKeyboard() {
    email.resignFirstResponder()
    password.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    super.keyboardWillShow(notification: notification)
    height.constant = 0
    UIView.animate(withDuration: 0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
  
  override func keyboardWillHide(notification:NSNotification) {
    super.keyboardWillHide(notification: notification)
    height.constant = 200
    UIView.animate(withDuration: 0.3) { () -> Void in
      self.view.layoutIfNeeded()
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == email) {
      password.becomeFirstResponder()
    }
    if (textField == password) {
      submit(submit)
    }
    return false
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    updateButtons();
    return true;
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    updateButtons();
    return true;
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    updateButtons();
  }
  
  func updateButtons() {
    let passwordText = password.text ?? "";
    let emailText = email.text ?? "";
    let enableLogin = !passwordText.isEmpty && emailText.isValidEmail();
    let enableForgot = emailText.isValidEmail();
    
    submit.isEnabled = enableLogin;
    submit.alpha = enableLogin ? 1.0 : 0.5;
    
    forgot.isEnabled = enableForgot;
    forgot.alpha = enableForgot ? 1.0 : 0.5;
  }
  
  func loginDidSucceed() {
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
    groupModel.error { (msg:String?) -> Void in
      self.showAlert(title: "Oops...", message: "Something went wrong.")
    }
    groupModel.getAll(user: UserModel.getCurrentUser()!)
  }

  @IBAction func gotoReset(_ sender: AnyObject) {
    forgot.isEnabled = false;
    forgot.alpha = 0.5;
    let resetModel = UserModel()
    resetModel.success { (msg:String?, model:AnyObject?) -> Void in
      self.showAlert(title: "Password reset", message: "Check your email for temporary password.")
      self.updateButtons();
    }
    resetModel.error { (data:String?) -> Void in
      self.showAlert(title: "Oops...", message: "Could not find user with that email.")
      self.updateButtons();
    }
    resetModel.resetPassword(email: email.text!)
  }
  
  @IBAction func submit(_ sender: UIButton) {
    submit.isEnabled = false;
    submit.alpha = 0.5;
    loginModel.login(email: email.text!, password: password.text!)
  }
}

