//
//  UserModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Foundation
import Alamofire

class UserModel : BaseModel {
  
  private static var currentUser:User?
  
  func create(username: String, email: String, password: String) {
    BaseModel.Manager.request(baseUrl + "users.json", method: .post, parameters: ["user": ["name": username, "email": email, "password": password]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error != nil {
          if let value = response.result.value as? [String: AnyObject] {
            callback(nil, User.fromDict(dict: value));
          }
        }
        if let callback = self._error {
          callback(self.parseError(resultData: response.data));
        }
      });
  }
  
  func get(user:User) {
    BaseModel.Manager.request(baseUrl + "users/" + String(user.id) + ".json", method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            let user = User.fromDict(dict: value);
            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.response?.url {
              let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
              print(cookies)
              user.session_id = cookies.first!.value
            }
            UserModel.setCurrentUser(user: user);
            callback(nil, user);
          }
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  func updateBirthday(user:User, components:[Int]) {
    let calendar = NSCalendar.current
    let dateComponents = DateComponents(calendar: calendar, year: 1916 + components[2], month: 1 + components[0], day: 1 + components[1]);
    let date = calendar.date(from: dateComponents);
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    updateField(user: user, field: "birthday", value: dateFormatter.string(from: date!))
  }
  
  func updatePassword(user:User, password:String) {
    updateField(user: user, field: "password", value: password)
  }
  
  func updateUsername(user:User, username:String) {
    updateField(user: user, field: "name", value: username)
  }
  
  func updatePushToken(user:User, token:Data) {
    let tokenString = token.toHexString()
    updateField(user: user, field: "push_token", value: tokenString)
  }
  
  private func updateField(user:User, field:String, value:String) {
    BaseModel.Manager.request(baseUrl + "users/" + String(user.id) + ".json", method: .put, parameters: ["user": [field: value]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error != nil {
          if let value = response.result.value as? [String: AnyObject] {
            let user = User.fromDict(dict: value);
            if let currentUser = UserModel.getCurrentUser() {
              user.session_id = currentUser.session_id
            }
            UserModel.setCurrentUser(user: user)
          }
          callback(nil, user);
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  func login(email: String, password: String) {
    BaseModel.Manager.request(baseUrl + "users/login.json", method: .post, parameters: ["email": email, "password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            let user = User.fromDict(dict: value);
            if let headerFields = response.response?.allHeaderFields as? [String: String], let URL = response.response?.url {
              let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
              print(cookies)
              user.session_id = cookies.first!.value
            }
            UserModel.setCurrentUser(user: user);
            callback(nil, user);
          }
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  func saveImage(user: User, image: UIImage) {
    // use "Aspect Fill" to resize the image
    let ratioW = 50 / image.size.width;
    let ratioH = 50 / image.size.height;
    let ratio = max(ratioW, ratioH)
    
    let size = image.size.applying(CGAffineTransform(scaleX: ratio, y: ratio))
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let ctx:CGContext = UIGraphicsGetCurrentContext()!;
    ctx.setStrokeColor(UIColor.lightGray.cgColor)
    ctx.strokeEllipse(in: CGRect.init(x: 1, y: 1, width: 48, height: 48))
    let path = UIBezierPath.init(ovalIn: CGRect(origin: CGPoint(x: 2.5, y: 2.5), size: CGSize(width: 45, height: 45)))
    path.addClip()
    image.draw(in: CGRect(origin: CGPoint(x: (45 - size.width) * 0.5, y: (45 - size.height) * 0.5), size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let imageData = UIImagePNGRepresentation(scaledImage!)
    let base64Data = imageData?.base64EncodedData()
    
    ImagesCache.sharedInstance.images[user.id] = scaledImage
    updateField(user: user, field: "image", value: String(data: base64Data!, encoding: String.Encoding.utf8)!)
  }
  
  static func setCurrentUser(user: User?) {
    currentUser = user
    let defaults = UserDefaults.standard
    if let user = user {
      defaults.set(user.toJson(), forKey: "current_user")
    } else {
      defaults.removeObject(forKey: "current_user")
    }
  }
  
  static func getCurrentUser() -> User? {
    if let currentUser = currentUser {
      return currentUser
    } else {
      let defaults = UserDefaults.standard
      if let user = defaults.dictionary(forKey: "current_user") {
        currentUser = User.fromDict(dict: user as Dictionary<String, AnyObject>)
        return currentUser
      }
    }
    return nil
  }
  
  func logout() {
    UserModel.setCurrentUser(user: nil)
  }
}

extension Data {
  func toHexString() -> String {
    return map { String(format: "%02hhX", $0) }.joined()
  }
}

