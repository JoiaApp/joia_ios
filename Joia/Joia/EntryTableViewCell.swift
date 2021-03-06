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
  @IBOutlet weak var mentionsLabel: UILabel!
  @IBOutlet weak var mentions: UILabel!
  @IBOutlet weak var customText: UILabel!
  @IBOutlet weak var prompt: UILabel!
  
  init() {
    super.init(style: .default, reuseIdentifier: "Cell")
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var response:Response? {
    set {
      customText.text = newValue!.prompt + " " + newValue!.text
      if !newValue!.mentions.isEmpty {
        mentions.text = newValue!.mentions.joined(separator: ", ")
        mentions.isHidden = false;
        mentionsLabel.isHidden = false;
      } else {
        mentions.isHidden = true;
        mentionsLabel.isHidden = true;
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
