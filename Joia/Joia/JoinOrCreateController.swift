//
//  JoinOrCreateController.swift
//  Joia
//
//  Created by Josh Bodily on 11/12/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class JoinOrCreateController : UIViewController {
  
  @IBAction func back(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func join(sender: AnyObject) {
    performSegueWithIdentifier("gotoJoin", sender: self)
  }
  
  @IBAction func create(sender: AnyObject) {
    performSegueWithIdentifier("gotoCreate", sender: self)
  }
}
