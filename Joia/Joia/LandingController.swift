//
//  LandingController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class LandingController : UIViewController {
  
//  @IBOutlet weak var signInButton: UIButton!
//  @IBOutlet weak var registerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func signInPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoLogin", sender: self)
  }
  
  @IBAction func registerPressed(sender: AnyObject) {
    performSegueWithIdentifier("gotoJoinOrCreate", sender: self)
  }
}
