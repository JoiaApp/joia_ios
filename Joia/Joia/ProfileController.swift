//
//  ProfileController.swift
//  Joia
//
//  Created by Josh Bodily on 12/4/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ProfileController : BaseController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var confirmPassword: UITextField!
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var birthday: UILabel!
  
  var imagePicker:UIImagePickerController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.update))
    self.image.addGestureRecognizer(tap)
  }
  
  override func viewDidAppear(_ animated: Bool) {
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
    
    if let userBirthday = currentUser.birthday {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = DateFormatter.Style.medium
      dateFormatter.timeZone = TimeZone.init(identifier: "UTC")!
      birthday.text = "Birthday - \(dateFormatter.string(from: userBirthday as Date))"
    } else {
      birthday.text = "Birthday - Not Set"
    }
  }
  @IBAction func editBirthday(_ sender: AnyObject) {
    let days = Array(1...31).map { String($0) }
    let years = Array(1916...2016).map { String($0) }
    let rows:Array<Array<String>> = [
      ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], days, years
    ]
    
    var calendar = NSCalendar.current
    calendar.timeZone = TimeZone.init(identifier: "UTC")!
    var components = calendar.dateComponents([.day, .month, .year], from: Date.init(timeIntervalSince1970: 0))
    if let userBirthday = UserModel.getCurrentUser()?.birthday {
      components = calendar.dateComponents([.day, .month, .year], from: userBirthday)
    }
    let initialSelection = [components.month! - 1, components.day! - 1, components.year! - 1916]
    
    ActionSheetMultipleStringPicker.show(withTitle: "Select ", rows: rows, initialSelection: initialSelection, doneBlock: {_,values,indices in
      let user = UserModel.getCurrentUser()
      let userModel = UserModel()
      userModel.success(callback: { (_, model) -> Void in
        let calendar = Calendar.current;
        let vals = values as! [Int]
        let dateComponents = DateComponents.init(calendar: calendar, year: 1916 + vals[2], month: 1 + vals[0], day: 1 + vals[1])
        let date = calendar.date(from: dateComponents)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium;
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        self.birthday.text = "Birthday - \(dateFormatter.string(from: date!))"
      })
      userModel.updateBirthday(user: user!, components: values as! [Int])
    }, cancel: nil, origin: self.view)
  }
  
  override func dismissKeyboard() {
    username.resignFirstResponder()
    password.resignFirstResponder()
    confirmPassword.resignFirstResponder()
  }
  
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if (textField == password) {
      password.resignFirstResponder()
      confirmPassword.becomeFirstResponder()
    }
    if (textField == confirmPassword) {
      confirmPassword.resignFirstResponder()
      if let password = password.text, let confirm = confirmPassword.text, password == confirm {
        updatePassword(password: password)
      } else {
        showAlert(title: "Oops", message: "Passwords don't match.")
      }
    }
    if (textField == username) {
      username.resignFirstResponder()
      if let username = username.text {
        updateUsername(name: username)
      }
    }
    return false
  }
  
  func textFieldDidEndEditing(_ textField:UITextField) {
    username.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
  }
  
  override func keyboardWillHide(notification:NSNotification) {
  }
  
  func updateUsername(name:String) {
    let userModel = UserModel()
    userModel.success { (_, model) -> Void in
      self.showAlert(title: "Success", message: "Username updated.")
    }
    userModel.updateUsername(user: UserModel.getCurrentUser()!, username: name)
  }
  
  func updatePassword(password:String) {
    let userModel = UserModel()
    userModel.success { (_, model) -> Void in
      self.showAlert(title: "Success", message: "Password updated.")
    }
    userModel.updatePassword(user: UserModel.getCurrentUser()!, password: password)
  }
  
  @IBAction func update(_ sender: AnyObject) {
    imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    self.imagePicker.dismiss(animated: true, completion: nil)
    image.image = info[UIImagePickerControllerOriginalImage] as! UIImage
    let userModel = UserModel()
    userModel.success { (_, _) -> Void in
      self.showAlert(title: "Success!", message: "Profile picture updated.")
    }
    userModel.saveImage(user: UserModel.getCurrentUser()!, image: image.image!)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.imagePicker.dismiss(animated: true, completion: nil)
  }
}
