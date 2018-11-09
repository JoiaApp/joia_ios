//
//  InvitesController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class InvitesController : BaseController, UITextFieldDelegate {
  
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var skip: UIButton!
  @IBOutlet weak var send: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func dismissKeyboard() {
    email.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    submit(textField)
    return false
  }
  
  func updateButtons(enabled:Bool) {
    send.isEnabled = enabled;
    send.alpha = enabled ? 1.0 : 0.5;
  }
  
  @IBAction func skip(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoCompose", sender: self)
  }
  
  @IBAction func submit(_ sender: AnyObject) {
    updateButtons(false);
    let groupModel = GroupModel()
    groupModel.success { (message:String?, _:AnyObject?) -> Void in
      self.showAlert(title: "Success!", message: "Email(s) sent!")
      self.skip.setTitle("Continue", for: .normal)
      self.updateButtons(true);
    }
    groupModel.error { (message:String?) -> Void in
      let messageUnwrapped = message ?? "Something went wrong."
      self.showAlert(title: "Oops!", message:messageUnwrapped)
      self.updateButtons(true);
    }
    groupModel.invite(email: email.text!, isMention: false, user_id: UserModel.getCurrentUser()!.id)
  }
}
