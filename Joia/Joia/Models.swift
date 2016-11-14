//
//  Models.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Foundation

public protocol Serializable {
  func toJson() -> Dictionary<String, AnyObject>
}

class Group : CustomStringConvertible, Serializable {
  let name:String;
  let guid:String;
  
  init(guid:String, name:String) {
    self.guid = guid;
    self.name = name;
  }
  
  var description:String {
    return "[<#Group> guid: \(guid) name \(name)]"
  }
  
  static func fromDict(dict:Dictionary<String, AnyObject>) -> Group {
    let unwrappedName = dict["name"] as! String
    let unwrappedGuid = dict["guid"] as! String
    return Group(guid: unwrappedGuid, name: unwrappedName)
  }
  
  func toJson() -> Dictionary<String, AnyObject> {
    return [
      "guid": self.guid,
      "name": self.name
    ]
  }
}

class User : CustomStringConvertible, Serializable {
  let name:String;
  let id:Int;
  
  init(id:Int, name:String) {
    self.id = id;
    self.name = name;
  }
  
  var description:String {
    return "[<#User> id: \(id) name \(name)]"
  }
  
  func toJson() -> Dictionary<String, AnyObject> {
    return [
      "id": self.id,
      "name": self.name
    ]
  }
  
  static func fromDict(dict:Dictionary<String, AnyObject>) -> User {
    let unwrappedId = dict["id"] as! String
    let unwrappedName = dict["name"] as! String
    return User(id: Int(unwrappedId)!, name: unwrappedName)
  }
}

class Prompt : CustomStringConvertible, Serializable {
  let text:String;
  let id:Int;
  
  init(id:Int, text:String) {
    self.id = id;
    self.text = text;
  }
  
  var description:String {
    return "[<#Prompt> id: \(id) text \(text)]"
  }
  
  func toJson() -> Dictionary<String, AnyObject> {
    return [
      "id": self.id,
      "text": self.text
    ]
  }
  
  static func fromDict(dict:Dictionary<String, AnyObject>) -> Prompt {
    let unwrappedId = dict["id"] as! String
    let unwrappedText = dict["text"] as! String
    return Prompt(id: Int(unwrappedId)!, text: unwrappedText)
  }
}