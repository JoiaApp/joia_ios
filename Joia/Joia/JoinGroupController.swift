//
//  JoinGroupController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class JoinGroupController : BaseController, UITextViewDelegate {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var topLabel: UILabel!
  @IBOutlet weak var topField: UITextField!
  @IBOutlet weak var bottomLabel: UILabel!
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var bottomField: UITextField!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func dismissKeyboard() {
    topField.resignFirstResponder()
    bottomField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == topField) {
      bottomField.becomeFirstResponder()
    }
    if (textField == bottomField) {
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
      model.get(topField.text!, password: bottomField.text!)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destinationViewController as! RegisterController)
      registerController.action = RegisterController.GroupAction.Join
    }
  }
  
}
