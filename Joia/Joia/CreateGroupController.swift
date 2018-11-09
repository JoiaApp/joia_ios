//
//  CreateGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class CreateGroupController : BaseController, UITextFieldDelegate {
  
  var createdGroup:Group!
  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var name: UITextField!
  @IBOutlet weak var submit: UIButton!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    name.delegate = self;
  }
  
  override func dismissKeyboard() {
    name.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == name) {
      submit(self)
    }
    return true
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
    let groupName = name.text ?? ""
    if (groupName.isEmpty) {
      self.showAlert(title: "Oops!", message: "Please enter a group name")
    } else {
      let model = GroupModel();
      model.success { (message:String?, model:AnyObject?) -> Void in
        GroupModel.setCurrentGroup(group: model as? Group)
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
      }
      model.error { (message:String?) -> Void in
        let unwrappedMessage = message ?? "Something went wrong"
        self.showAlert(title: "Oops!", message: unwrappedMessage)
        self.submit.alpha = 1.0
        self.submit.isEnabled = true
      }
      model.create(name: groupName)
      submit.alpha = 0.5
      submit.isEnabled = false
    }
  }
}
