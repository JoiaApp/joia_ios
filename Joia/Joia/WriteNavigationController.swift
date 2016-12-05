
//
//  File.swift
//  Joia
//
//  Created by Josh Bodily on 11/29/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class WriteNavigationController : UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewControllerWithIdentifier("Write")
    self.pushViewController(controller, animated: true)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
}
