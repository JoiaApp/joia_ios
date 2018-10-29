//
//  BaseModel.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class BaseModel {
  
  static var Manager : Alamofire.SessionManager = {
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
      "joia-dev.us-west-2.elasticbeanstalk.com": .disableEvaluation,
      "joia-staging.us-west-2.elasticbeanstalk.com": .disableEvaluation
    ]
    
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    
    return Alamofire.SessionManager(
      configuration: configuration,
      serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
  }()
  
  var baseUrl:String {
    get { return Config.baseUrl; }
  }
  
  var _success: ((String?, AnyObject?) -> Void)? = nil
  var _successMany: ((String?, [AnyObject]?) -> Void)? = nil
  var _error: ((String?) -> Void)? = nil
  
  func success(callback: @escaping (String?, _:AnyObject?) -> Void) {
    _success = callback;
  }
  
  func successMany(callback: @escaping (String?, _:[AnyObject]?) -> Void) {
    _successMany = callback;
  }
  
  func error(callback: @escaping (String?) -> Void) {
    _error = callback;
  }
  
  func parseError(resultData:Data?) -> String? {
    if let data = resultData {
      if let json = String(data: data as Data, encoding: String.Encoding.utf8) {
        let obj = JSON.init(parseJSON: json)
        if let error = obj["error"].string {
          return error
        }
      }
    }
    return nil
  }
}
