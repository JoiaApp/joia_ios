//
//  WriteController.swift
//  Joia
//
//  Created by Josh Bodily on 11/29/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit
import TagListView
import ActionSheetPicker_3_0

class WriteController : BaseController, TagListViewDelegate, UITextViewDelegate {
  
  @IBOutlet weak var response: UITextView!
  @IBOutlet weak var promptNumber: UILabel!
  @IBOutlet weak var customPrompt: UITextField!
  @IBOutlet weak var promptLabel: UILabel!
  @IBOutlet weak var mentions: TagListView!
  
  @IBOutlet weak var mentionsPlaceholder: UILabel!
  var prompts:Array<Prompt>?
  var users:Array<User>?
  var index:Int!
  var currentPrompt:String?
  
  @IBAction func changePrompt(sender: AnyObject) {
    if let prompts = prompts {
      var rows = prompts.map { $0.text }
      rows.append("Custom Prompt")
      var current = rows.indexOf(promptLabel.text ?? "") ?? rows.count - 1
      if (promptLabel.hidden) {
        current = rows.count - 1
      }
      ActionSheetMultipleStringPicker.showPickerWithTitle("Select Prompt",
        rows: [rows], initialSelection: [current], doneBlock: {_,values,indices in
          self.setPrompt(indices[0] as! String)
      }, cancelBlock: nil, origin: self.view)
    }
  }
  
  @IBAction func promptChanged(sender: AnyObject) {
    ResponseModel.setPrompt(index, prompt: customPrompt.text ?? "")
    updateNextButton()
  }
  
  func textViewDidChange(textView:UITextView) {
    ResponseModel.setResponse(index, response: response.text)
    updateNextButton()
  }
  
  func updateNextButton() {
    var enabled = response.text.characters.count > 10 && (!promptLabel.hidden || customPrompt.text!.characters.count > 0)
    self.navigationItem.rightBarButtonItem!.enabled = enabled;
  }
  
  func setPrompt(prompt:String) {
    if prompt == "Custom Prompt" {
      customPrompt.hidden = false
      customPrompt.text = ""
      promptLabel.hidden = true
      ResponseModel.setPrompt(index, prompt: "")
    } else {
      promptLabel.hidden = false
      promptLabel.text = prompt
      customPrompt.hidden = true
      ResponseModel.setPrompt(index, prompt: prompt)
    }
  }
  
  func selectMention() {
    if let users = users {
      let rows = users.map { $0.name }
      ActionSheetMultipleStringPicker.showPickerWithTitle("Select ", rows: [rows], initialSelection: [0], doneBlock: {_,values,indices in
        let selected = indices[0] as! String
        for tagView in self.mentions.tagViews {
          if (tagView.titleLabel!.text! == selected) { return }
        }
        var view = self.mentions.addTag(selected)
        view.tag = users[values[0] as! Int].id
        if let imageData = ImagesCache.sharedInstance.images[view.tag] {
          view.image.image = imageData
        }
        self.updateMentions()
      }, cancelBlock: nil, origin: self.view)
    }
  }
  
  func tagPressed(title: String, tagView: TagView, sender: TagListView) -> Void {
    for tag in mentions.tagViews { tag.selected = false }
    tagView.selected = true
    selectMention()
  }
  
  func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) -> Void {
    mentions.removeTag(title)
    updateMentions()
  }
  
  func updateMentions() {
    var ids:[Int] = []
    for tagView in self.mentions.tagViews {
      ids.append(Int(tagView.tag))
    }
    ResponseModel.setMentions(index, mentions:ids)
    mentionsPlaceholder.hidden = self.mentions.tagViews.count > 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nextButton = UIBarButtonItem.init(title: "Next", style: .Plain, target: self, action: Selector("gotoNext"))
    nextButton.enabled = false
    self.navigationItem.rightBarButtonItem = nextButton
    
    let borderColor = UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0)
    mentions.superview?.addBottomBorderWithColor(borderColor, width: 1)
    mentions.superview?.addTopBorderWithColor(UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0), width: 1)
    
    let tap = UITapGestureRecognizer(target: self, action: Selector("selectMention"))
    mentions.addGestureRecognizer(tap)
    mentions.delegate = self
    
    promptLabel.hidden = true
  }
  
  override func viewDidAppear(animated:Bool) {
    super.viewDidAppear(animated)
    promptNumber.text = "Prompt \(index + 1) of 3"
    
    if let currentPrompt = currentPrompt {
      setPrompt(currentPrompt)
    }
  }
  
  override func dismissKeyboard() {
    response.resignFirstResponder()
    customPrompt.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    
  }
  
  func gotoNext() {
    if let writeNavigationController = self.navigationController as? WriteNavigationController {
      writeNavigationController.gotoNext()
    }
  }
}


extension UIView {
  func addTopBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.CGColor
    border.frame = CGRectMake(-20, 0, self.frame.size.width, width)
    self.layer.addSublayer(border)
  }
  
  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.CGColor
    border.frame = CGRectMake(-20, self.frame.size.height - width, self.frame.size.width, width)
    self.layer.addSublayer(border)
  }
}
