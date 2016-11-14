//
//  UserModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire

class UserModel : BaseModel<User> {
  
  func create(username: String, email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users.json", parameters: ["user": ["name": username, "email": email, "password": password]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
//          callback("Success")
        }
        if let callback = self._error where result.isFailure {
          callback("Oops, something went wrong")
        }
      });
  }
}