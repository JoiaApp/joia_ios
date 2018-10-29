//
//  BaseController.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class BaseController : UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    self.view.addGestureRecognizer(tap)
  }
  
  @IBAction func back(_ sender: AnyObject) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func dismissKeyboard() {
    
  }
  
  func showAlert(title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.view.tintColor = APP_COLOR
    let OKAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(OKAction)
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func keyboardWillShow(notification:NSNotification) {
    let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
    UIView.animate(withDuration: 0.3, animations: {
      var frame = self.view.frame;
      frame.origin.y = -keyboardSize.height;
      self.view.frame = frame;
    })
  }
  
  @objc func keyboardWillHide(notification:NSNotification) {
    UIView.animate(withDuration: 0.3, animations: {
      var frame = self.view.frame;
      frame.origin.y = 0;
      self.view.frame = frame;
    })
  }
}
