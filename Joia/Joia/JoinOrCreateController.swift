//
//  JoinOrCreateController.swift
//  Joia
//
//  Created by Josh Bodily on 11/12/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class JoinOrCreateController : UIViewController {
  
  @IBOutlet weak var createButton: UIButton!
  @IBOutlet weak var joinButton: UIButton!
  
  @IBAction func join(sender: AnyObject) {
    performSegueWithIdentifier("gotoJoin", sender: self)
  }
  
  @IBAction func create(sender: AnyObject) {
    performSegueWithIdentifier("gotoCreate", sender: self)
  }
}
