//
//  PromptModel.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import Alamofire

class PromptModel : BaseModel {
  func get(group:Group) {
    Alamofire.request(.GET, baseUrl + "groups/" + group.guid + "/prompts.json", parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (_, response, result) -> Void in
        if let callback = self._success where result.isSuccess {
          var prompts:[Prompt] = Array()
          if let array = result.value as? [AnyObject] {
            for item in array {
              let prompt = Prompt.fromDict(item as! [String: AnyObject])
              prompts.append(prompt)
            }
          }
          callback(nil, prompts)
        }
        if let callback = self._error where result.isFailure {
          callback(nil)
        }
      });
  }
}
