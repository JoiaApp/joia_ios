//
//  ViewController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class LoginController : BaseController, UITextFieldDelegate {
  
  var loginModel:LoginModel!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var submit: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loginModel = LoginModel()
    loginModel.success { (data:String?) -> Void in
      self.performSegueWithIdentifier("gotoCompose", sender: self)
    }
    loginModel.error { (data:String?) -> Void in
      self.showAlert("Oops...", message: "Something went wrong")
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if (textField == password) {
      loginModel.login(email.text!, password: password.text!)
    }
    return false
  }
  
  @IBAction func submit(sender: AnyObject) {
    loginModel.login(email.text!, password: password.text!)
  }
  
  @IBAction func loginPressed(sender: UIButton) {
    loginModel.login(email.text!, password: password.text!)
  }
}

