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
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.init(name: "OpenSans-Semibold", size: 20)!];
    self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
  }
  
  func initialize() {
    self.popToRootViewControllerAnimated(false);
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewControllerWithIdentifier("writeZeroState") as! UIViewController
    let nextButton = UIBarButtonItem.init(title: "Next", style: .Plain, target: self, action: Selector("gotoNext"))
    controller.navigationItem.rightBarButtonItem = nextButton
    controller.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    self.pushViewController(controller, animated: false)
    ResponseModel.composing = true
    
    // Get Prompts
    let promptModel = PromptModel()
    promptModel.success { (message:String?, model:AnyObject?) -> Void in
      self.prompts = model as! Array<Prompt>
      self.randomPrompts = PromptModel.choose(3, from: self.prompts.count)
      
      if let viewController = self.topViewController as? WriteController {
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
    var currentIndex = 0
    
    if let viewController = self.topViewController as? WriteController {
      currentIndex = viewController.index + 1
    }
    
    if (currentIndex < 3) {
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewControllerWithIdentifier("Write") as! WriteController
      controller.prompts = prompts
      controller.users = users
      controller.index = currentIndex
      controller.currentPrompt = self.prompts[ self.randomPrompts![currentIndex] ].text
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
