//
//  ProfileController.swift
//  Joia
//
//  Created by Josh Bodily on 12/4/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit
import WDImagePicker

class ProfileController : BaseController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var confirmPassword: UITextField!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var password: UITextField!
  
  var imagePicker:UIImagePickerController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    guard let _ = UserModel.getCurrentUser() else {
      // Logout?
      return
    }
    
    let currentUser = UserModel.getCurrentUser()!
    username.text = currentUser.name
    if let cachedImage = ImagesCache.sharedInstance.images[currentUser.id] {
      image.image = cachedImage
    }
  }
  
  override func dismissKeyboard() {
    username.resignFirstResponder()
    password.resignFirstResponder()
    confirmPassword.resignFirstResponder()
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if (textField == password) {
      password.resignFirstResponder()
      confirmPassword.becomeFirstResponder()
    }
    if (textField == confirmPassword) {
      confirmPassword.resignFirstResponder()
      if let password = password.text, confirm = confirmPassword.text where password == confirm {
        updatePassword(password)
      } else {
        showAlert("Oops", message: "Passwords don't match.")
      }
    }
    if (textField == username) {
      username.resignFirstResponder()
      if let username = username.text {
        updateUsername(username)
      }
    }
    return false
  }
  
  func textFieldDidEndEditing(textField:UITextField) {
    username.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
  }
  
  override func keyboardWillHide(notification:NSNotification) {
  }
  
  func updateUsername(name:String) {
    let userModel = UserModel()
    userModel.success { (_, model) -> Void in
      self.showAlert("Success", message: "Username updated.")
    }
    userModel.updateUsername(UserModel.getCurrentUser()!, username: name)
  }
  
  func updatePassword(password:String) {
    let userModel = UserModel()
    userModel.success { (_, model) -> Void in
      self.showAlert("Success", message: "Password updated.")
    }
    userModel.updatePassword(UserModel.getCurrentUser()!, password: password)
  }
  
  @IBAction func update(sender: AnyObject) {
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .PhotoLibrary
    self.presentViewController(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    image.image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let userModel = UserModel()
    userModel.success { (_, _) -> Void in
      self.showAlert("Success!", message: "Profile picture updated.")
    }
    userModel.saveImage(UserModel.getCurrentUser()!, image: image.image!)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
  }
}