//
//  InvitesController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class InvitesController : BaseController {
  
  @IBOutlet weak var email: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func dismissKeyboard() {
    email.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    submit(textField)
    return false
  }
  
  @IBAction func skip(sender: AnyObject) {
    performSegueWithIdentifier("gotoCompose", sender: self)
  }
  
  @IBAction func submit(sender: AnyObject) {
    let groupModel = GroupModel()
    groupModel.success { (message:String?, _:AnyObject?) -> Void in
      self.showAlert("Success!", message:"Email sent!")
    }
    groupModel.error { (message:String?) -> Void in
      let messageUnwrapped = message ?? "Something went wrong."
      self.showAlert("Oops!", message:messageUnwrapped)
    }
    groupModel.invite(email.text!, isMention: false)
  }
}