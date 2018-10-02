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
    let dataDecoded:NSData = NSData(base64Encoded: data, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
    images[id] = decodedimage
  }
}
