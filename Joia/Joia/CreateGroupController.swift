//
//  CreateGrouop.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class CreateGroupController : BaseController {
  
  var createdGroup:Group!
  @IBOutlet weak var name: UITextField!
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destinationViewController as! RegisterController)
      registerController.join = true
      registerController.group = createdGroup
    }
  }
  
  @IBAction func submit(sender: AnyObject) {
    let model = GroupModel();
    model.success { (message:String?) -> Void in
      print("SUCCESS")
    }
    model.error { (message:String?) -> Void in
      self.showAlert("Oops", message: message!)
    }
    model.create(name.text!)
  }
}
