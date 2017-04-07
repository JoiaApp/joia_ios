//
//  EntryTableViewCell.swift
//  Joia
//
//  Created by Josh Bodily on 11/16/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class EntryTableViewCell : UITableViewCell {
  
  @IBOutlet weak var customImage: UIImageView!
  @IBOutlet weak var user: UILabel!
  @IBOutlet weak var customText: UILabel!
  @IBOutlet weak var prompt: UILabel!
  
  init() {
    super.init(style: .Default, reuseIdentifier: "Cell")
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var response:Response? {
    set {
      customText.text = newValue!.prompt + " " + newValue!.text
      if let mentions = newValue!.mentions {
        user.text = "With " + newValue!.mentions!.joinWithSeparator(" ")
      } else {
        user.text = "With "
      }
      prompt.text = newValue!.user?.name ?? ""
      if let user = newValue!.user {
        if let imageData = ImagesCache.sharedInstance.images[user.id] {
          customImage.image = imageData
        }
      }
    }
    get {
      return nil
    }
  }
}
