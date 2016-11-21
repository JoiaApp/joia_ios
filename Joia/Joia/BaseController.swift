//
//  BaseController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class BaseController : UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
    self.view.addGestureRecognizer(tap)
  }
  
  func dismissKeyboard() {
    
  }
  
  func showAlert(title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
      
    }
    alert.addAction(OKAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  func keyboardWillShow(notification:NSNotification) {
    let keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
    UIView.animateWithDuration(0.3) { () -> Void in
      var frame = self.view.frame;
      frame.origin.y = -keyboardSize.height;
      self.view.frame = frame;
    }
  }
  
  func keyboardWillHide(notification:NSNotification) {
    UIView.animateWithDuration(0.3) { () -> Void in
      var frame = self.view.frame;
      frame.origin.y = 0;
      self.view.frame = frame;
    }
  }
}
