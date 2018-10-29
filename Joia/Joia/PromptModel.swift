//
//  PromptModel.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Alamofire

class PromptModel : BaseModel {
  func get() {
    BaseModel.Manager.request(baseUrl + "prompts.json", method: .get, parameters: nil)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseJSON(completionHandler: { (response) in
        if let callback = self._successMany, response.error == nil {
          var prompts:[Prompt] = Array()
          if let array = response.result.value as? [AnyObject] {
            for item in array {
              let prompt = Prompt.fromDict(dict: item as! [String: AnyObject])
              prompts.append(prompt)
            }
          }
          callback(nil, prompts);
        }
        if let callback = self._error, response.error != nil {
          callback("Failed to fetch prompts :(")
        }
      });
  }
  
  static func choose(howMany:Int, prompts: Array<Prompt>) -> Array<Prompt> {
    return prompts[randomPick: 3];
  }
}

extension Array {
  subscript (randomPick n: Int) -> [Element] {
    var copy = self
    for i in stride(from: count - 1, to: count - n - 1, by: -1) {
      copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
    }
    return Array(copy.suffix(n))
  }
}
