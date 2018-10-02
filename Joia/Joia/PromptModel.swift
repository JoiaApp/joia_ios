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
        if let callback = self._success, response.error == nil {
          var prompts:[Prompt] = Array()
          if let array = response.result.value as? [AnyObject] {
            for item in array {
              let prompt = Prompt.fromDict(dict: item as! [String: AnyObject])
              prompts.append(prompt)
            }
          }
          // TODO: Fix me!
//          callback(nil, prompts)
        }
        if let callback = self._error, response.error != nil {
          callback(nil)
        }
      });
  }
  
  static func choose(howMany:Int, from:Int) -> Array<Int> {
//    let cal = Calendar.current
//    let date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
//    let secondsSince = date?.timeIntervalSince1970
//    let seconds = Int(secondsSince!)
//    srand48(seconds)
//    (drand48() * 100_000_000).truncatingRemainder(dividingBy: 32)
    
    // TODO: Fix me
//    let cal = Calendar.current
//    let components = cal.dateComponents(in: TimeZone.current, from: Date())
//    srand(UInt32(components.month! + components.day!))
//    var options = Array(0..<from)
//    var chosen:[Int] = []
//    for _ in 0..<howMany {
//      let index:Int = Int(arc4random() % UInt32(options.count))
//      chosen.append(options[index])
//      options.remove(at: index)
//    }
//    return chosen
    return [];
  }
  
//  func seeded_rand(seed:Int, min:Double, max:Double) -> Int
//  {
//    srand48(seed)
//    return Int(round(drand48() * (max-min)) + min)
//  }
}
