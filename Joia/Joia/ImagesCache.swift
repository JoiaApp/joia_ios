//
//  ImagesCache.swift
//  Joia
//
//  Created by Josh Bodily on 12/5/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class ImagesCache {
  var images:[Int:UIImage] = [:]
  static let sharedInstance = ImagesCache()
  
  func put(id:Int, data:String) {
    let dataDecoded:NSData = NSData(base64EncodedString: data, options: NSDataBase64DecodingOptions(rawValue: 0))!
    let decodedimage:UIImage = UIImage(data: dataDecoded)!
    images[id] = decodedimage
  }
}