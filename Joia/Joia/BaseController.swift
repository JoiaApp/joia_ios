//
//  BaseController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class BaseController : UIViewController {
  
  func showAlert(title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
      
    }
    alert.addAction(OKAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
}
