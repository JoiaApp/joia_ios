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
  
  static var currentUser:User?
  
  func create(username: String, email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users.json", parameters: ["user": ["name": username, "email": email, "password": password]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            callback(nil, User.fromDict(value));
          }
        }
        if let callback = self._error where result.isFailure {
          callback(self.parseError(result.data))
        }
      });
  }
  
  func get(user:User) {
    Alamofire.request(.POST, baseUrl + "users/" + String(user.id) + "/refresh.json", parameters: nil, encoding: .URL, headers: ["Cookie": "_srv_session=" + (user.session_id ?? "")])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let user = User.fromDict(value);
            if let headerFields = response?.allHeaderFields as? [String: String], URL = response?.URL {
              let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(headerFields, forURL: URL)
              print(cookies)
              user.session_id = cookies.first!.value
            }
            UserModel.setCurrentUser(user);
            callback(nil, user);
          }
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
  
  func updateBirthday(user:User, components:[Int]) {
    let dateComponents = NSDateComponents()
    dateComponents.month = 1 + components[0]
    dateComponents.day = 1 + components[1]
    dateComponents.year = 1916 + components[2]
    let calendar = NSCalendar.currentCalendar()
    let date = calendar.dateFromComponents(dateComponents)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    updateField(user, field: "birthday", value: dateFormatter.stringFromDate(date!))
  }
  
  func updatePassword(user:User, password:String) {
    updateField(user, field: "password", value: password)
  }
  
  func updateUsername(user:User, username:String) {
    updateField(user, field: "name", value: username)
  }
  
  func updatePushToken(user:User, token:NSData) {
    let tokenString = token.toHexString()
    updateField(user, field: "push_token", value: tokenString)
  }
  
  private func updateField(user:User, field:String, value:String) {
    Alamofire.request(.PUT, baseUrl + "users/" + String(user.id) + ".json", parameters: ["user": [field: value]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let user = User.fromDict(value);
            if let currentUser = UserModel.getCurrentUser() {
              user.session_id = currentUser.session_id
            }
            UserModel.setCurrentUser(user)
          }
          callback(nil, user);
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
  
  func login(email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users/login.json", parameters: ["email": email, "password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let user = User.fromDict(value);
            if let headerFields = response?.allHeaderFields as? [String: String], URL = response?.URL {
              let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(headerFields, forURL: URL)
              print(cookies)
              user.session_id = cookies.first!.value
            }
            UserModel.setCurrentUser(user);
            callback(nil, user);
          }
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
  
  func saveImage(user: User, image: UIImage) {
    // use "Aspect Fill" to resize the image
    let ratioW = 50 / image.size.width;
    let ratioH = 50 / image.size.height;
    let ratio = max(ratioW, ratioH)
    
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(ratio, ratio))
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
//    let minimum = min(size.width, size.height)
    
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    let path = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: 50, height: 50)))
    path.addClip()
    image.drawInRect(CGRect(origin: CGPoint(x: (50 - size.width) * 0.5, y: (50 - size.height) * 0.5), size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
//    print(scaledImage)
    
    let imageData = UIImagePNGRepresentation(scaledImage)
    let base64Data = imageData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
    
    ImagesCache.sharedInstance.images[user.id] = scaledImage
    updateField(user, field: "image", value: String(data: base64Data!, encoding: NSUTF8StringEncoding)!)
    
//    Alamofire.request(.POST, baseUrl + "users/" + String(user.id) + "/upload.json", parameters: ["image": String(data: base64Data!, encoding: NSUTF8StringEncoding)!])
//      .validate(statusCode: 200..<300)
//      .validate(contentType: ["application/octet-stream"])
//      .responseJSON(completionHandler: { (_, response, result) -> Void in
//        ImagesCache.sharedInstance.images[user.id] = scaledImage
//          let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//          if (imageData!.writeToFile(documentsPath + "/" + String(user.id) + ".png", atomically: true)) {
//            print(documentsPath)
//          }
//      })
  }
  
  static func setCurrentUser(user: User) {
    currentUser = user
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(user.toJson(), forKey: "current_user")
  }
  
  static func getCurrentUser() -> User? {
    if let currentUser = currentUser {
      return currentUser
    } else {
      let defaults = NSUserDefaults.standardUserDefaults()
      if let user = defaults.dictionaryForKey("current_user") {
        currentUser = User.fromDict(user)
        return currentUser
      }
    }
    return nil
  }
  
  static func logout() {
    
  }
}

extension NSData {
  func toHexString() -> String {
    var hexString: String = ""
    let dataBytes =  UnsafePointer<CUnsignedChar>(self.bytes)
    for (var i: Int=0; i<self.length; ++i) {
      hexString +=  String(format: "%02X", dataBytes[i])
    }
    return hexString
  }
}