//
//  RegisterController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class RegisterController : BaseController {
  
  var join:Bool!
  var group:Group!
  
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var username: UITextField!
  
  @IBAction func submit(sender: AnyObject) {
    let model = UserModel();
    
    model.success { (message:String?) -> Void in
      if (true /*self.join!*/) {
        self.performSegueWithIdentifier("gotoCompose", sender: self)
      } else {
        self.performSegueWithIdentifier("gotoInvite", sender: self)
      }
    }
    model.error { (message:String?) -> Void in
      self.showAlert("Oops", message: message!)
    }
    
    model.create(username.text!, email: email.text!, password: password.text!)
  }
}