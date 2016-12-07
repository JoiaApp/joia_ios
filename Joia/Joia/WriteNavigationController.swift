//
//  WriteNavigationController.swift
//  Joia
//
//  Created by Josh Bodily on 11/29/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class WriteNavigationController : UINavigationController {
  
  var randomPrompts:Array<Int>?
  var prompts:Array<Prompt> = []
  var users:Array<User> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize()
  }
  
  func initialize() {
    self.popToRootViewControllerAnimated(false);
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewControllerWithIdentifier("Write") as! WriteController
    controller.index = 0
    self.pushViewController(controller, animated: false)
    ResponseModel.composing = true
    
    // Get Prompts
    let promptModel = PromptModel()
    promptModel.success { (message:String?, model:AnyObject?) -> Void in
      self.prompts = model as! Array<Prompt>
      if let viewController = self.topViewController as? WriteController {
        self.randomPrompts = PromptModel.choose(3, from: self.prompts.count)
        viewController.prompts = self.prompts
        viewController.setPrompt(self.prompts[ self.randomPrompts![0] ].text)
      }
    }
    promptModel.get()
    
    // Get peers
    let groupModel = GroupModel()
    groupModel.success { (message:String?, model:AnyObject?) -> Void in
      self.users = model as! Array<User>
      if let viewController = self.topViewController as? WriteController {
        viewController.users = self.users
      }
    }
    
    groupModel.getMembers(GroupModel.getCurrentGroup()!.guid)
  }
  
  func gotoNext() {
    print("gotoNext")
    var index = 0
    if let viewController = self.topViewController as? WriteController {
      index = viewController.index
    }
    // go to the next prompt
    if (index < 2) {
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("Write") as! WriteController
      controller.prompts = prompts
      controller.users = users
      controller.index = index + 1
      controller.currentPrompt = self.prompts[ self.randomPrompts![index + 1] ].text
      self.pushViewController(controller, animated: false)
    } else {
    // else, go to the review page
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("Review") as! ReviewController
      self.pushViewController(controller, animated: false)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    // Check if they are already composing their responses
    if (!ResponseModel.composing) {
      initialize()
    }
  }
}
