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
import AddressBookUI

class WriteController : BaseController, TagListViewDelegate, UITextViewDelegate, ABPeoplePickerNavigationControllerDelegate {
  
  @IBOutlet weak var response: UITextView!
  @IBOutlet weak var promptNumber: UILabel!
  @IBOutlet weak var customPrompt: UITextField!
  @IBOutlet weak var promptLabel: UILabel!
  @IBOutlet weak var mentions: TagListView!
  @IBOutlet weak var mentionButton: UIButton!
  
  @IBOutlet weak var mentionsPlaceholder: UILabel!
  var prompts:Array<Prompt>?
  var users:Array<User>?
  var index:Int!
  var currentPrompt:String?
  var picker:AbstractActionSheetPicker?
  
  @IBAction func changePrompt(sender: AnyObject) {
    if let prompts = prompts {
      var rows = prompts.map { $0.text }
      rows.append("Custom Prompt")
      var current = rows.indexOf(promptLabel.text ?? "") ?? rows.count - 1
      if (promptLabel.hidden) {
        current = rows.count - 1
      }
      self.picker = ActionSheetMultipleStringPicker.showPickerWithTitle("Select Prompt",
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
    response.scrollRangeToVisible(response.selectedRange)
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range:NSRange, replacementText text:String) -> Bool {
//  func textView(textView: UITextView, shouldChangeTextIn range: NSRange, replacementText replacement: String) -> Bool {
    let currentText = response.text as NSString
    let updatedText = currentText.stringByReplacingCharactersInRange(range, withString: text)
    if updatedText.isEmpty || updatedText == "Write response here..." {
      response.text = "Write response here..."
      response.textColor = UIColor.lightGrayColor()
      response.selectedTextRange = response.textRangeFromPosition(response.beginningOfDocument, toPosition: response.beginningOfDocument)
      return false
    } else if textView.textColor == UIColor.lightGrayColor() && !updatedText.isEmpty {
      textView.text = ""
      textView.textColor = UIColor.blackColor()
    }
    
    return true
  }
  
  func textViewDidChangeSelection(textView: UITextView) {
    if self.view.window != nil {
      let firstPosition = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
      if (response.selectedRange.location == 0) {
        return
      }
      if response.textColor == UIColor.lightGrayColor() && response.selectedRange.location != 0 {
        response.selectedTextRange = firstPosition
      }
    }
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
  
  @IBAction func addMention(sender: AnyObject) {
    selectMention()
  }
  
  func selectMention() {
    dismissKeyboard()
    if let users = users {
      var rows = users.map { $0.name }
      rows.insert("Select Contact...", atIndex: 0)
      rows.insert("Enter Email...", atIndex: 0)
      ActionSheetMultipleStringPicker.showPickerWithTitle("Select ", rows: [rows], initialSelection: [0], doneBlock: {_,values,indices in
        let selected = indices[0] as! String
        if (selected == "Select Contact...") {
          let picker = ABPeoplePickerNavigationController()
          picker.peoplePickerDelegate = self;
          self.presentViewController(picker, animated: true, completion: nil);
          return
        } else if (selected == "Enter Email...") {
          self.createEmailAlert()
          return
        }
        for tagView in self.mentions.tagViews {
          if (tagView.titleLabel!.text! == selected) { return }
        }
        
        var view = self.mentions.addTag(selected)
        view.accessibilityIdentifier = String(users[values[0]as! Int - 2].id)
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
    var ids:[String] = []
    for tagView in self.mentions.tagViews {
      ids.append(tagView.accessibilityIdentifier!)
    }
    ResponseModel.setMentions(index, mentions:ids)
    mentionsPlaceholder.hidden = self.mentions.tagViews.count > 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nextButton = UIBarButtonItem.init(title: "Next", style: .Plain, target: self, action: Selector("gotoNext"))
    nextButton.enabled = false
    
    nextButton.tintColor = UIColor.whiteColor()
    nextButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
    nextButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans", size: 16)!, NSForegroundColorAttributeName: DISABLED_COLOR], forState: .Disabled)
    self.navigationItem.rightBarButtonItem = nextButton
    self.navigationItem.title = "Write"
    
    let borderColor = UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0)
    mentions.superview?.addBottomBorderWithColor(borderColor, width: 1)
    mentions.superview?.addTopBorderWithColor(UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0), width: 1)
    
    let tap = UITapGestureRecognizer(target: self, action: Selector("selectMention"))
    mentions.addGestureRecognizer(tap)
    mentions.delegate = self
    
    promptLabel.hidden = true
    
    if let _ = response.text?.isEmpty {
      response.text = "Write response here..."
      response.textColor = UIColor.lightGrayColor()
      response.selectedTextRange = response.textRangeFromPosition(response.beginningOfDocument, toPosition: response.beginningOfDocument)
      response.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
    }
    
    mentionButton.layer.borderColor = APP_COLOR.CGColor
    
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    
    let buttonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
    buttonItem.tintColor = UIColor.whiteColor()
    self.navigationController?.navigationBar.backItem?.title = "";
  }
  
  override func viewDidAppear(animated:Bool) {
    super.viewDidAppear(animated)
    promptNumber.text = "Prompt \(index + 1) of 3"
    
    if let currentPrompt = currentPrompt {
      setPrompt(currentPrompt)
    }
    
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.title = "Write"
  }
  
  override func dismissKeyboard() {
    response.resignFirstResponder()
    customPrompt.resignFirstResponder()
  }
  
  func gotoNext() {
    if let writeNavigationController = self.navigationController as? WriteNavigationController {
      writeNavigationController.gotoNext()
    }
  }
  
  func createEmailAlert() {
    let alertController = UIAlertController(title: "Add Mention", message: "An invite will be sent to the following email after your response is published.", preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
      let emailField = alertController.textFields![0] as? UITextField
      if let email = emailField?.text {
        let view = self.mentions.addTag(email)
        view.accessibilityIdentifier = String(email)
        self.updateMentions()
      }
    }
    alertController.addAction(OKAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
      
    }
    alertController.addAction(cancelAction)
    alertController.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Email"
      textField.keyboardType = UIKeyboardType.EmailAddress
      NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { notification in
        OKAction.enabled = textField.text != ""
      }
    }
    self.presentViewController(alertController, animated: true, completion: nil)
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
    let list: ABMultiValueRef = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() //
    let index = Int(0) as CFIndex
    if (ABMultiValueGetCount(list) > 0) {
      let email:String = ABMultiValueCopyValueAtIndex(list, index).takeRetainedValue() as! String
      
      let view = self.mentions.addTag(email)
      view.accessibilityIdentifier = String(email)
      self.updateMentions()
      
    } else {
      
    }
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, shouldContinueAfterSelectingPerson person: ABRecord, property: ABPropertyID, identifier: ABMultiValueIdentifier) -> Bool {
    return false
  }
  
  override func keyboardWillShow(notification:NSNotification) {
  }
  
  override func keyboardWillHide(notification:NSNotification) {
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
