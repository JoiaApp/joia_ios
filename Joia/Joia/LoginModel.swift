//
//  LoginModel.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire

class LoginModel : BaseModel {
  
  func login(email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users/login.json", parameters: ["email": email, "password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let user = User.fromDict(value);
            UserModel.setCurrentUser(user);
            callback(nil, user);
          }
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }

}