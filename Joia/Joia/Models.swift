//
//  Models.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Foundation

public protocol Serializable {
  func toJson() -> Dictionary<String, AnyObject>
}

class Mention : Serializable {
  let response:Int
  let user:Int
  init(response:Int, user:Int) {
    self.response = response
    self.user = user
  }
  
  func toJson() -> Dictionary<String, AnyObject> {
    return [
      "response_id": self.response,
      "user_id": self.user
    ]
  }
}

class Response : CustomStringConvertible, Serializable {
  let text:String;
  let prompt:String;
  let user:User?;
  let mentions:[String];
  var date:NSDate?
  
  init(text:String, prompt:String, user:User?, mentions:[String]) {
    self.text = text;
    self.prompt = prompt;
    self.user = user;
    self.mentions = mentions;
  }
  
  var description:String {
    return "[<#Response> text: '\(text)' user:\(user?.name ?? "nil") prompt: \(prompt ?? "nil")]"
  }
  
  static func fromDict(dict:Dictionary<String, AnyObject>) -> Response {
    let unwrappedText = dict["text"] as! String
    let unwrappedPrompt = dict["prompt"] as! String
    let unwrappedUser = dict["user"] as! Dictionary<String, AnyObject>
    let unwrappedMentions = dict["mentions"] as! Array<AnyObject>
    
    var names = Array<String>()
    for mention in unwrappedMentions {
      let mentionUser = mention as! [String: AnyObject]
      let user = mentionUser["user"] as! [String: AnyObject]
      let name = user["name"] as! String
      names.append(name)
    }
    
    let response = Response(text: unwrappedText, prompt: unwrappedPrompt, user:User.fromDict(unwrappedUser), mentions:names)
    if let date = dict["created_at"] as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
      response.date = dateFormatter.dateFromString(date)
    }
    
    return response
  }
  
  func toJson() -> Dictionary<String, AnyObject> {
    return [
      "text": self.text,
      "prompt": self.prompt,
      "user_id": self.user!.id
    ]
  }
}

class Group : CustomStringConvertible, Serializable {
  var name:String;
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
  var session_id:String?;
  var image:String?
  var birthday:NSDate?
  
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
      "name": self.name,
      "session_id": self.session_id ?? "",
      "image": self.image ?? ""
    ]
  }
  
  static func fromDict(dict:Dictionary<String, AnyObject>) -> User {
    let unwrappedId = dict["id"] as! Int
    let unwrappedName = dict["name"] as! String
    let user = User(id: unwrappedId, name: unwrappedName)
    if let sessionId = dict["session_id"] as? String {
      user.session_id = sessionId
    }
    if let image = dict["image"] as? String where image.characters.count > 0 {
      user.image = image
      ImagesCache.sharedInstance.put(unwrappedId, data: image)
    }
    if let birthday = dict["birthday"] as? String {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
      user.birthday = dateFormatter.dateFromString(birthday)
    }
    return user
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
    let unwrappedId = dict["id"] as! Int
    let unwrappedText = dict["phrase"] as! String
    return Prompt(id: unwrappedId, text: unwrappedText)
  }
}