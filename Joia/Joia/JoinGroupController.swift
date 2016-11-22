//
//  JoinGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class JoinGroupController : BaseController, UITextViewDelegate {
  
  @IBOutlet weak var code: UITextField!
  @IBOutlet weak var key: UITextField!
  @IBOutlet weak var submit: UIButton!
  @IBOutlet weak var height: NSLayoutConstraint!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func dismissKeyboard() {
    code.resignFirstResponder()
    key.resignFirstResponder()
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
    if (textField == code) {
      key.becomeFirstResponder()
    }
    if (textField == key) {
      submit(self)
    }
    return false
  }
    
  @IBAction func submit(sender: AnyObject) {
      let model = GroupModel();
      model.success { (message:String?, object:AnyObject?) -> Void in
        GroupModel.setCurrentGroup(object as! Group)
        self.performSegueWithIdentifier("gotoRegister", sender: self)
      }
      model.error { (message:String?) -> Void in
        self.showAlert("Oops...", message: "Group number or password incorrect.")
      }
      model.get(code.text!, password: key.text!)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destinationViewController as! RegisterController)
      registerController.action = RegisterController.GroupAction.Join
    }
  }
  
}
