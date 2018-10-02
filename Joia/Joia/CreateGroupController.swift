//
//  CreateGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class CreateGroupController : BaseController, UITextViewDelegate {
  
  var createdGroup:Group!
  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var name: UITextField!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func dismissKeyboard() {
    name.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == name) {
      submit(self)
    }
    return false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destination as! RegisterController)
      registerController.action = RegisterController.GroupAction.Create
    }
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    super.keyboardWillShow(notification: notification)
    height.constant = 0
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    });
  }
  
  override func keyboardWillHide(notification:NSNotification) {
    super.keyboardWillHide(notification: notification)
    height.constant = 200
    UIView.animate(withDuration: 0.3, animations: {
      self.view.layoutIfNeeded()
    });
  }
  
  @IBAction func submit(_ sender: AnyObject) {
    let model = GroupModel();
    model.success { (message:String?, model:AnyObject?) -> Void in
      GroupModel.setCurrentGroup(group: model as? Group)
      self.performSegue(withIdentifier: "gotoRegister", sender: self)
    }
    model.error { (message:String?) -> Void in
      let unwrappedMessage = message ?? "Something went wrong"
      self.showAlert(title: "Oops!", message: unwrappedMessage)
    }
    model.create(name: name.text!)
  }
}
