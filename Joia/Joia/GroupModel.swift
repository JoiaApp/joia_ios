//
//  GroupModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire

class GroupModel : BaseModel<Group> {
  
  func create(name: String) {
    Alamofire.request(.POST, baseUrl + "groups.json", parameters: ["group": ["name": name]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            callback("Success", Group.fromDict(value));
          }
        }
        if let callback = self._error where result.isFailure {
          callback("Oops! Something went wrong.")
        }
      });
  }
  
  func get(number: String, password: String) {
    Alamofire.request(.GET, baseUrl + "groups/" + number + ".json", parameters: ["password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            callback("Success", Group.fromDict(value));
          }
          
        }
        if let callback = self._error where result.isFailure {
          callback("Group number not recognized.")
        }
      });
  }
  
}