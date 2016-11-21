//
//  TableCell.swift
//  Joia
//
//  Created by Josh Bodily on 11/16/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class EntryTableViewCell : UITableViewCell {
  
  @IBOutlet weak var user: UILabel!
  @IBOutlet weak var customText: UILabel!
  @IBOutlet weak var prompt: UILabel!
  var response:Response? {
  set {
    customText.text = newValue!.text
    user.text = newValue!.user!.name
    prompt.text = newValue!.prompt!.text
  }
  get {
    return nil
  }
  }
}
