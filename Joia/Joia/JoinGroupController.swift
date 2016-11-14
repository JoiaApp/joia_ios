//
//  GroupsController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class JoinGroupController : BaseController {
  
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var bottomField: UITextField!
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    label.alpha = 0.0
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      self.label.alpha = 1.0
      }, completion: nil)
  }
    
  @IBAction func submit(sender: AnyObject) {
      let model = GroupModel();
      model.success { (message:String?) -> Void in
        self.performSegueWithIdentifier("gotoRegister", sender: self)
      }
      model.error { (message:String?) -> Void in
        self.showAlert("Oops...", message: "Something went wrong")
      }
      model.get(topField.text!, password: bottomField.text!)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "gotoRegister") {
      let registerController = (segue.destinationViewController as! RegisterController)
      registerController.join = false
      registerController.group = nil
    }
  }
  
}
