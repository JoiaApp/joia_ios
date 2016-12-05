//
//  ResponseModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Alamofire

struct UnpublishedResponse {
  var prompt:String
  var response:String
}

class ResponseModel : BaseModel {
  
  var tempResponses:[UnpublishedResponse] = []
  
  func setTempResponse(prompt:String, response:String) {
    let unpublishedResponse = UnpublishedResponse(prompt: prompt, response: response);
    tempResponses.append(unpublishedResponse)
  }
  
  func getTempResponse(index:Int) -> UnpublishedResponse? {
//    return tempResponses[promptId]
    return nil
  }
  
//  func publishTempResponses(prompt
  
//  func submitResponses(group:Group, user:User) {
//    let responses:[Response] = tempResponses.map {
//      let prompt = Prompt(id: $0, text:"")
//      return Response(text: $1, prompt:prompt, user:user)
//    }
//    for response in responses {
//      Alamofire.request(.POST, baseUrl + "groups/" + group.guid + "/responses.json", parameters: ["response": response.toJson()])
//        .validate(statusCode: 200..<300)
//        .validate(contentType: ["application/json"])
//        .responseJSON(completionHandler: { (_, response, result) -> Void in
//
//        });
//    }
//  }
//  
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