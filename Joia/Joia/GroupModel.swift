//
//  GroupModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation
import Alamofire

class GroupModel : BaseModel {
  
  static var currentGroup:Group?
  
  func create(name: String) {
    Alamofire.request(.POST, baseUrl + "groups.json", parameters: ["group": ["name": name]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let group = Group.fromDict(value);
            callback(nil, group);
          }
        }
        if let callback = self._error where result.isFailure {
          callback(self.parseError(result.data))
        }
      });
  }
  
  func update(group: Group) {
    Alamofire.request(.PUT, baseUrl + "groups/" + group.guid + ".json", parameters: ["group": group.toJson()])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
  }
  
  func join(user:User) {
    Alamofire.request(.POST, baseUrl + "groups/" + GroupModel.currentGroup!.guid + "/join.json", parameters: ["user_id": user.id])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            callback(nil, Group.fromDict(value));
          }
        }
        if let callback = self._error where result.isFailure {
          callback(self.parseError(result.data))
        }
      });
  }
  
  func invite(email:String) {
    Alamofire.request(.POST, baseUrl + "groups/" + GroupModel.currentGroup!.guid + "/invite.json", parameters: ["email": email])
      .validate(statusCode: 200..<300)
      .response(completionHandler: { (_, response, data, error) -> Void in
        if let callback = self._success where response!.statusCode == 204 {
          callback("Sent!", nil)
        }
        else if let callback = self._error {
          callback(self.parseError(data))
        }
      })
  }
  
  func get(number: String, password: String) {
    Alamofire.request(.GET, baseUrl + "groups/" + number + ".json", parameters: ["password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          if let value = result.value as? [String: AnyObject] {
            let group = Group.fromDict(value);
            callback(nil, group);
          }
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
  
  func getAll(user: User) {
    Alamofire.request(.GET, baseUrl + "users/" + String(user.id) + "/groups.json", parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          var groups:[Group] = Array()
          if let array = result.value as? [AnyObject] {
            for item in array {
              let group = Group.fromDict(item as! [String: AnyObject])
              groups.append(group)
            }
          }
          callback(nil, groups)
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
  
  static func setCurrentGroup(group:Group?) {
    currentGroup = group;
  }
  
  static func getCurrentGroup() -> Group? {
    return currentGroup;
  }
  
}