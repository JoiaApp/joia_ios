//
//  WriteNavigationController.swift
//  Joia
//
//  Created by Josh Bodily on 11/29/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class WriteNavigationController : UINavigationController {
  
  var randomPrompts:Array<Prompt> = []
  var prompts:Array<Prompt> = []
  var users:Array<User> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialize();
    
    self.navigationBar.titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "OpenSans-Semibold", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white];
    self.navigationBar.tintColor = UIColor.white;
  }
  
  func initialize() {
    self.popToRootViewController(animated: false);
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "writeZeroState")
    let nextButton = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: #selector(self.gotoNext));
    controller.navigationItem.rightBarButtonItem = nextButton;
    controller.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    controller.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white], for: [])
    self.pushViewController(controller, animated: false)
    controller.navigationItem.title = "Write"
    ResponseModel.composing = true
    
    // Get Prompts
    let promptModel = PromptModel()
    promptModel.successMany { (message:String?, model:[AnyObject]?) -> Void in
      self.prompts = model as! Array<Prompt>
      self.randomPrompts = PromptModel.choose(howMany: 3, prompts: self.prompts)
      if let viewController = self.topViewController as? WriteController {
        viewController.prompts = self.prompts
        viewController.setPrompt(prompt: self.randomPrompts[0].text)
      }
    }
    promptModel.error { (message:String?) in
      let alert = UIAlertController(title: "Oops", message: message!, preferredStyle: .alert)
      alert.view.tintColor = APP_COLOR
      let OKAction = UIAlertAction(title: "OK", style: .default)
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
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
    
    groupModel.getMembers(number: GroupModel.getCurrentGroup()!.guid)
  }
  
  @objc func gotoNext() {
    var currentIndex = 0
    
    if let viewController = self.topViewController as? WriteController {
      currentIndex = viewController.index + 1
    }
    
    if (currentIndex < 3) {
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: "Write") as! WriteController
      controller.prompts = prompts
      controller.users = users
      controller.index = currentIndex
      controller.currentPrompt = self.randomPrompts[currentIndex].text
      self.pushViewController(controller, animated: false)
    } else {
      // else, go to the review page
      let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: "Review") as! ReviewController
      self.pushViewController(controller, animated: false)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Check if they are already composing their responses
    if (!ResponseModel.composing) {
      initialize()
    }
  }
}
