//
//  GroupModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/13/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Foundation
import Alamofire

class GroupModel : BaseModel {
  
  static var currentGroup:Group?
  
  func create(name: String) {
    BaseModel.Manager.request(baseUrl + "groups.json", method: .post, parameters: ["group": ["name": name]])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            let group = Group.fromDict(dict: value);
            callback(nil, group);
          }
        }
        if let callback = self._error, response.error != nil {
          callback(self.parseError(resultData: response.data))
        }
      });
  }
  
  func update(group: Group) {
    BaseModel.Manager.request(baseUrl + "groups/" + group.guid + ".json", method: .put, parameters: ["group": group.toJson()])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            let group = Group.fromDict(dict: value)
            GroupModel.setCurrentGroup(group: group)
            callback(nil, group);
          }
        }
        if let callback = self._error, response.error != nil {
          callback(self.parseError(resultData: response.data))
        }
      });
  }
  
  func join(user:User) {
    BaseModel.Manager.request(baseUrl + "groups/" + GroupModel.currentGroup!.guid + "/join.json", method: .post, parameters: ["user_id": user.id])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            callback(nil, Group.fromDict(dict: value));
          }
        }
        if let callback = self._error, response.error != nil {
          callback(self.parseError(resultData: response.data))
        }
      });
  }
  
  func invite(email:String, isMention: Bool, user_id:Int) {
    BaseModel.Manager.request(baseUrl + "groups/" + GroupModel.currentGroup!.guid + "/invite.json", method: .post, parameters: ["email": email, "isMention": isMention, "user_id": user_id])
      .validate(statusCode: 200..<300)
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.response?.statusCode == 204 {
          callback("Sent!", nil)
        }
        else if let callback = self._error {
          callback(self.parseError(resultData: response.data))
        }
      })
  }
  
  func get(number: String, password: String) {
    BaseModel.Manager.request(baseUrl + "groups/" + number + ".json", method: .get, parameters: ["password": password])
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          if let value = response.result.value as? [String: AnyObject] {
            let group = Group.fromDict(dict: value);
            callback(nil, group);
          }
        }
        if let callback = self._error, response.error != nil  {
          callback(nil)
        }
      });
  }
  
  func getMembers(number: String) {
    BaseModel.Manager.request(baseUrl + "groups/" + number + "/members.json", method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          var users:[User] = Array()
          if let array = response.result.value as? [AnyObject] {
            for item in array {
              let user = User.fromDict(dict: item as! [String: AnyObject])
              users.append(user)
              // Save the images
              let userData = item as! [String: AnyObject]
              if let imageData = userData["image"] as? String {
                let dataDecoded:NSData = NSData(base64Encoded: imageData, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
                let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                ImagesCache.sharedInstance.images[user.id] = decodedimage
              }
            }
          }
          callback(nil, users as AnyObject)
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  func getAll(user: User) {
    BaseModel.Manager.request(baseUrl + "users/" + String(user.id) + "/groups.json", method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          var groups:[Group] = Array()
          if let array = response.result.value as? [AnyObject] {
            for item in array {
              let group = Group.fromDict(dict: item as! [String: AnyObject])
              groups.append(group)
            }
          }
          callback(nil, groups as AnyObject)
        }
        if let callback = self._error, response.error != nil {
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
