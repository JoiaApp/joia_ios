//
//  ResponseModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Alamofire

struct UnpublishedResponse {
  var prompt:String?
  var response:String?
  var mentions:[String] = []
}

class ResponseModel : BaseModel {
  
  static var tempResponses:[Int:UnpublishedResponse] = [:]
  
  static func setPrompt(index:Int, prompt:String) {
    if let _ = tempResponses[index] {
      tempResponses[index]!.prompt = prompt
    } else {
      let unpublishedResponse = UnpublishedResponse.init(prompt: prompt, response: nil, mentions:[])
      tempResponses[index] = unpublishedResponse
    }
  }
  
  static func setResponse(index:Int, response:String) {
    if let _ = tempResponses[index] {
      tempResponses[index]!.response = response
    } else {
      let unpublishedResponse = UnpublishedResponse.init(prompt: nil, response: response, mentions:[])
      tempResponses[index] = unpublishedResponse
    }
  }
  
  static func setMentions(index:Int, mentions:[String]) {
    if let _ = tempResponses[index] {
      tempResponses[index]!.mentions = mentions
    } else {
      let unpublishedResponse = UnpublishedResponse.init(prompt: nil, response: nil, mentions:mentions)
      tempResponses[index] = unpublishedResponse
    }
  }
  
  static func getTempResponse(index:Int) -> UnpublishedResponse? {
    return tempResponses[index]
  }
  
  static var _composing:Bool = false
  static var composing:Bool {
    get {
      return _composing
    }
    set {
      _composing = newValue
    }
  }
  
  func publishResponses(group:Group, user:User) -> Bool {
    let responses:[Response] = ResponseModel.tempResponses.map { Response(text: $1.response!, prompt: $1.prompt!, user:user, mentions:$1.mentions ) }
    var success = true;
    
    for response in responses {
      BaseModel.Manager.request(baseUrl + "groups/" + group.guid + "/responses.json", method: .post, parameters: ["response": response.toJson()])
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON(completionHandler: { (remote_response) in
          if (remote_response.error != nil) {
            success = false
          } else if let value = remote_response.result.value as? [String: AnyObject] {
            for mentionedUser in response.mentions {
              // User in group mention
//              if let id = Int(mentionedUser) {
//                let mention = Mention(response:value["id"] as! Int, user: id)
//                BaseModel.Manager.request(self.baseUrl + "groups/" + group.guid + "/mentions.json", method: .post, parameters: ["mention": mention.toJson()])
//                  .validate(statusCode: 200..<300)
//                  .validate(contentType: ["application/json"])
//              } else {
                if (mentionedUser.isValidEmail()) {
                  GroupModel().invite(email: mentionedUser, isMention: true, user_id: UserModel.getCurrentUser()!.id)
                }
              }
            }
          });
    }
    
    // Done composing
    ResponseModel.composing = false
    return success
  }

//  func validate() -> Bool {
//    for (_, response) in tempResponses {
//      let trimmed = response.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//      if trimmed.characters.count > 10 {
//        continue
//      } else {
//        return false
//      }
//    }
//    return true
//  }
  
  func getThread(group:Group) {
    BaseModel.Manager.request(baseUrl + "groups/" + group.guid + "/responses.json", method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._success, response.error == nil {
          var responses:[Response] = Array()
          if let array = response.result.value as? [AnyObject] {
            for item in array {
              let response = Response.fromDict(dict: item as! [String: AnyObject])
              responses.append(response)
            }
          }
          callback(nil, responses as AnyObject)
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  static func relativeDateStringForDate(date : Date) -> NSString {
    let components = Calendar.current.dateComponents([.hour, .day, .month, .year, .weekOfYear], from: date, to: Date())

    let year =  components.year!
    let month = components.month!
    let day = components.day!
    let weeks = components.weekOfYear!

    if year > 0 {
      return NSString.init(format: "%d years ago", year);
    } else if month > 0 {
      return NSString.init(format: "%d months ago", month);
    } else if weeks > 0 {
      return NSString.init(format: "%d weeks ago", weeks);
    } else if (day > 0) {
      if day > 1 {
        return NSString.init(format: "%d days ago", day);
      } else {
        return "Yesterday";
      }
    } else {
      return "Today";
    }
  }
}

extension String {
  func isValidEmail() -> Bool {
    // here, `try!` will always succeed because the pattern is valid
    let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
    return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
  }
}
