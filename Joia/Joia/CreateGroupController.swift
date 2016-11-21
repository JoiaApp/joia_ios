//
//  CreateGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class CreateGroupController : BaseController, UITextViewDelegate {
  
  var createdGroup:Group!
  @IBOutlet weak var name: UITextField!
  
  override func viewDidAppear(animated: Bool) {
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destinationViewController as! RegisterController)
      registerController.action = RegisterController.GroupAction.Create
    }
  }
  
  @IBAction func submit(sender: AnyObject) {
    let model = GroupModel();
    model.success { (message:String?, model:AnyObject?) -> Void in
      GroupModel.setCurrentGroup(model as! Group)
      self.performSegueWithIdentifier("gotoRegister", sender:self)
    }
    model.error { (message:String?) -> Void in
      let unwrappedMessage = message ?? "Something went wrong"
      self.showAlert("Oops!", message: unwrappedMessage)
    }
    model.create(name.text!)
  }
}
