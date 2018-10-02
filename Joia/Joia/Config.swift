//
//  Config.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

struct Config {
  static var baseUrl = "http://localhost.charlesproxy.com:3000/"
}

let PRODUCTION_URL = "http://sample-env.qd8vv2zefd.us-west-2.elasticbeanstalk.com/"
let STAGING_URL = "http://sample-env.qd8vv2zefd.us-west-2.elasticbeanstalk.com/"
let CHARLES_URL = "http://localhost.charlesproxy.com:3000/"
let LOCAL_URL = "http://localhost:3000/"

let GROUPS_INDEX:Int = 2

// Colors
let APP_COLOR = UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0)
let DISABLED_COLOR = UIColor(red:238/255.0, green:238/255.0, blue:238/255.0, alpha: 1.0)

// Debugging
//let DEBUG_GROUP = Group(guid: "a937ec91", name: "Joia Devs")
//let DEBUG_USER = User(id: 1, name: "Test User")
