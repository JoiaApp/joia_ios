//
//  JoinGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class JoinGroupController : BaseController, UITextViewDelegate {
  
  @IBOutlet weak var code: UITextField!
  @IBOutlet weak var key: UITextField!
  @IBOutlet weak var submit: UIButton!
  @IBOutlet weak var height: NSLayoutConstraint!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func dismissKeyboard() {
    code.resignFirstResponder()
    key.resignFirstResponder()
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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == code) {
      key.becomeFirstResponder()
    }
    if (textField == key) {
      submit(self);
    }
    return false
  }
    
  @IBAction func submit(_ sender: AnyObject) {
      let model = GroupModel();
      model.success { (message:String?, object:AnyObject?) -> Void in
        GroupModel.setCurrentGroup(group: object as! Group)
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
      }
      model.error { (message:String?) -> Void in
        self.showAlert(title: "Oops...", message: "Group number or password incorrect.")
      }
    model.get(number: code.text!, password: key.text!)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destination as! RegisterController)
      registerController.action = RegisterController.GroupAction.Join
    }
  }
  
}
