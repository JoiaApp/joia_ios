//
//  WriteController.swift
//  Joia
//
//  Created by Josh Bodily on 11/14/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class WriteController : BaseController, UITextViewDelegate {
  
  @IBOutlet weak var prompt: UILabel!
  @IBOutlet weak var numPrompts: UILabel!
  @IBOutlet weak var response: UITextView!
  @IBOutlet weak var height: NSLayoutConstraint!
  @IBOutlet weak var submit: UIButton!
  @IBOutlet weak var button: UIButton!
  @IBOutlet weak var stack: UIStackView!
  @IBOutlet weak var textView: UITextView!
  
  var currentIndex:Int = 0
  var responseModel:ResponseModel!
  var todaysPrompts:Array<Prompt>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    responseModel = ResponseModel()
  }
  
  override func viewDidAppear(animated:Bool) {
    super.viewDidAppear(animated)
    guard let _ = GroupModel.getCurrentGroup() else {
      let alert = UIAlertController(title: "No group selected", message: "Please select a group", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        NSNotificationCenter.defaultCenter().postNotificationName("gotoGroups", object: nil)
      }
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
      return
    }
    
    let promptModel = PromptModel()
    promptModel.success { (message:String?, model:AnyObject?) -> Void in
      self.todaysPrompts = model as? Array<Prompt>
      self.setCurrentPrompt(0)
      for subview in self.stack.subviews {
        subview.removeFromSuperview()
      }
      for prompt in self.todaysPrompts! {
        let label = UILabel()
        label.userInteractionEnabled = true
        label.text = prompt.text
        let tap = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        label.addGestureRecognizer(tap)
        self.stack.addArrangedSubview(label)
      }
    }
    promptModel.error { (message:String?) -> Void in
      self.showAlert("Oops", message: "Couldn't get any prompts for today!")
    }
    promptModel.get(GroupModel.getCurrentGroup()!)
  }
  
  @IBAction func tap(sender: AnyObject) {
    var index = 0
    for label in stack.subviews {
      if label == sender.view as! UILabel {
        break;
      }
      index++
    }
    setCurrentPrompt(index)
    if let response =  responseModel.getTempResponse(todaysPrompts![index].id) {
      self.response.text = response
    } else {
      self.response.text = ""
    }
  }
  
  @IBAction func drawerButton(sender: AnyObject) {
    dismissKeyboard()
    if (height.constant == 70) {
      openPromptDrawer();
    } else {
      closePromptDrawer();
    }
  }
  
  func openPromptDrawer() {
    stack.alpha = 0
    height.constant = 200
    UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.view.layoutIfNeeded()
      self.button.transform = CGAffineTransformMakeRotation(3.14);
      self.stack.alpha = 1
      }, completion: nil)
  }
  
  func closePromptDrawer() {
    stack.alpha = 1
    height.constant = 70
    UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.view.layoutIfNeeded()
      self.button.transform = CGAffineTransformMakeRotation(0);
      self.stack.alpha = 0
      }, completion: nil)
  }
  
  override func dismissKeyboard() {
    textView.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {

  }
  
  func setCurrentPrompt(index:Int) {
    self.numPrompts.text = "Prompt (\(index + 1) / \(self.todaysPrompts!.count)) for today"
    self.prompt.text = self.todaysPrompts![index].text
    self.currentIndex = index
    closePromptDrawer()
  }
  
  func textViewDidChange(textView: UITextView) {
    if let prompt = todaysPrompts?[currentIndex]  {
      responseModel.putTempResponse(prompt.id, response: textView.text!)
      submit.enabled = responseModel.validate()
    }
  }
  
  @IBAction func submit(sender: AnyObject) {
    responseModel.submitResponses(GroupModel.getCurrentGroup()!, user:UserModel.getCurrentUser()!)
  }
}
