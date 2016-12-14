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
  var mentions:[Int] = []
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
  
  static func setMentions(index:Int, mentions:[Int]) {
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
    let responses:[Response] = ResponseModel.tempResponses.map { Response(text: $1.response!, prompt: $1.prompt!, user:user, mentions:$1.mentions ?? []) }
    var success = true;
    for response in responses {
      Alamofire.request(.POST, baseUrl + "groups/" + group.guid + "/responses.json", parameters: ["response": response.toJson()])
        .validate(statusCode: 200..<300)
        .validate(contentType: ["application/json"])
        .responseJSON(completionHandler: { (_, _, result) -> Void in
          if (!result.isSuccess) {
            success = false
          } else if let value = result.value as? [String: AnyObject] {
            for mentionedUserId in response.mentions! {
              let mention = Mention(response:value["id"] as! Int, user:mentionedUserId)
              Alamofire.request(.POST, self.baseUrl + "groups/" + group.guid + "/mentions.json", parameters: ["mention": mention.toJson()])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
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
    Alamofire.request(.GET, baseUrl + "groups/" + group.guid + "/responses.json", parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          var responses:[Response] = Array()
          if let array = result.value as? [AnyObject] {
            for item in array {
              let response = Response.fromDict(item as! [String: AnyObject])
              responses.append(response)
            }
          }
          callback(nil, responses)
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
}