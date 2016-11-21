//
//  UserModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
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
  
  static func setCurrentUser(user: User) {
    let defaults = NSUserDefaults.standardUserDefaults()
    currentUser = user;
    defaults.setInteger(user.id, forKey: "user_id")
    defaults.setObject(user.name, forKey: "user_name")
    defaults.synchronize()
  }
  
  static func getCurrentUser() -> User? {
    let defaults = NSUserDefaults.standardUserDefaults()
    let id = defaults.integerForKey("user_id")
    if let name = defaults.objectForKey("user_name") as? String {
      currentUser = User(id: id, name: name)
      return currentUser
    }
    return nil
  }
  
  static func logout() {
    currentUser = nil
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.removeObjectForKey("user_name")
    defaults.removeObjectForKey("user_id")
    defaults.synchronize()
  }
}