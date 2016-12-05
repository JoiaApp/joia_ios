//
//  File2.swift
//  Joia
//
//  Created by Josh Bodily on 11/29/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit
import TagListView
import ActionSheetPicker_3_0

class WriteController : BaseController, TagListViewDelegate, UITextViewDelegate {
  
  // Custom Prompt Changed
  @IBAction func promptChanged(sender: AnyObject) {
    print(text.text!)
  }
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var promptNumber: UILabel!
  @IBOutlet weak var text: UITextField!
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var mentions: TagListView!
  var prompts:Array<Prompt>?
  
  @IBAction func changePrompt(sender: AnyObject) {
//    if let prompts = prompts {
//      var rows:[String] = prompts.map { return $0.text }
    var rows = ["I laughed when...", "I smiled when..."]
      rows.append("Custom Prompt")
      var current = 0
//      if let i = rows.indexOf(prompt.text!) {
//        current = i
//      }
      ActionSheetMultipleStringPicker.showPickerWithTitle("Select Prompt", rows: [rows], initialSelection: [current], doneBlock: {_,values,indices in
        print(values)
        self.setPrompt(indices[0] as! String)
        }, cancelBlock: nil, origin: self.view)
//    }
  }
  
  func setPrompt(prompt:String) {
    if prompt == "Custom Prompt" {
      text.hidden = false
      label.hidden = true
      text.text = ""
    } else {
      label.hidden = false
      text.hidden = true
      label.text = prompt
    }
  }
  
  func selectMention() {
    let rows = [["Danny", "Josh"]]
    ActionSheetMultipleStringPicker.showPickerWithTitle("Select Prompt", rows: rows, initialSelection: [0], doneBlock: {_,values,indices in
      //      print(values)
      let selected = indices[0] as! String
      for tagView in self.mentions.tagViews {
        if (tagView.titleLabel!.text! == selected) { return }
      }
      self.mentions.addTag(selected)
      }, cancelBlock: nil, origin: self.view)
  }
  
  func tagPressed(title: String, tagView: TagView, sender: TagListView) -> Void {
    for tag in mentions.tagViews { tag.selected = false }
    tagView.selected = true
    selectMention()
  }
  
  func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) -> Void {
    mentions.removeTag(title)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

//    let promptModel = PromptModel()
//    promptModel.success { (_, model) -> Void in
//      self.prompts = model as! Array<Prompt>
//    }
//    promptModel.error { (message:String?) -> Void in
//      print("true")
//    }
//    promptModel.get()
    
    let nextButton = UIBarButtonItem.init(title: "Next", style: .Plain, target: self, action: Selector("gotoNext"))
    nextButton.enabled = false
    self.navigationItem.rightBarButtonItem = nextButton
    
    mentions.superview?.addBottomBorderWithColor(UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0), width: 1)
    mentions.superview?.addTopBorderWithColor(UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0), width: 1)
//    mentions.superview?.layer.borderColor = UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0).CGColor
    mentions.addTag("Josh Bodily")
    mentions.addTag("Danny Anderson")
    
    let tap = UITapGestureRecognizer(target: self, action: Selector("selectMention"))
    mentions.addGestureRecognizer(tap)
    mentions.delegate = self
    
    label.hidden = true
  }
  
  func textViewDidChange(textView: UITextView) {
    
  }
  
  override func dismissKeyboard() {
    textView.resignFirstResponder()
    text.resignFirstResponder()
  }
  
  override func keyboardWillShow(notification:NSNotification) {
    
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
