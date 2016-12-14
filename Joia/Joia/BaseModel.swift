//
//  BaseModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel {
  
  var baseUrl:String {
    get { return Config.baseUrl; }
  }
  
  var _success: ((String?, AnyObject?) -> Void)? = nil
  var _error: ((String?) -> Void)? = nil
  
  func success(callback: (String?, model:AnyObject?) -> Void) {
    _success = callback;
  }
  
  func error(callback: (String?) -> Void) {
    _error = callback;
  }
  
  func parseError(resultData:NSData?) -> String? {
    if let data = resultData {
      if let json = String(data: data, encoding: NSUTF8StringEncoding) {
        let obj = JSON.parse(json)
        if let error = obj["error"].string {
          return error
        }
      }
    }
    return nil
  }
}
