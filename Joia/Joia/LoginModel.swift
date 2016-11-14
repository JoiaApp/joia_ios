//
//  LoginModel.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire

class BaseModel<T> {
  
  let baseUrl:String = "http://localhost.charlesproxy.com:3000/"
  var _success: ((String?, T?) -> Void)? = nil
  var _error: ((String?) -> Void)? = nil
  
  func success(callback: (String?, model:T?) -> Void) {
    _success = callback;
  }
  
  func error(callback: (String?) -> Void) {
    _error = callback;
  }
}

class LoginModel : BaseModel<User> {
  
  func login(email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users/login.json", parameters: ["email": email, "password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          callback("Success")
        }
        if let callback = self._error where result.isFailure {
          callback("Failure")
        }
      });
  }
  
  func register(name: String, email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "users.json", parameters: ["user": ["name": "josh", "password": "foo"]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let callback = self._success {
          callback("Success")
        }
    }
  }
  
  func joinGroup(groupId: String, groupPassword: String) {
    Alamofire.request(.POST, baseUrl + "/groups/join", parameters: ["user_id": 1, "group_id": 2])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let callback = self._success {
          callback("Success")
        }
    }
  }
  
  func createGroup(name: String, groupPassword: String) {
    Alamofire.request(.POST, baseUrl + "/groups", parameters: ["group": []])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let callback = self._success {
          callback("Success")
        }
    }
  }
  
  func sendEmailInvite(email: String, password: String) {
    Alamofire.request(.POST, baseUrl + "/groups/invite", parameters: ["invites": []])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON { response in
        if let callback = self._success {
          callback("Success")
        }
    }
  }
}