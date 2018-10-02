//
//  JoinOrCreateController.swift
//  Joia
//
//  Created by Josh Bodily on 11/12/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class JoinOrCreateController : UIViewController {
  
  @IBAction func back(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func join(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoJoin", sender: self)
  }
  
  @IBAction func create(_ sender: AnyObject) {
    performSegue(withIdentifier: "gotoCreate", sender: self)
  }
}
