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
    BaseModel.Manager.request(.GET, baseUrl + "prompts.json", parameters: nil)
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
  
  static func choose(howMany:Int, from:Int) -> Array<Int> {
    let cal = NSCalendar.currentCalendar()
    let components = cal.components([.Month, .Day, .TimeZone], fromDate: NSDate())
    srand(UInt32(components.month + components.day))
    var options = Array(0..<from)
    var chosen:[Int] = []
    for _ in 0..<howMany {
      let index:Int = Int(rand() % Int32(options.count))
      chosen.append(options[index])
      options.removeAtIndex(index)
    }
    return chosen
  }
}
