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
  
  @IBAction func changePrompt(_ sender: AnyObject) {
    if let prompts = prompts {
      var rows = prompts.map { $0.text }
      rows.append("Custom Prompt")
      var current = rows.index(of: promptLabel.text ?? "") ?? rows.count - 1
      if (promptLabel.isHidden) {
        current = rows.count - 1
      }
      
      self.picker = ActionSheetMultipleStringPicker.show(withTitle: "Select Prompt",
        rows: [rows], initialSelection: [current], doneBlock: {_,values /* [Any]? */, indices  in
          // TODO: Fix me!!
//          self.setPrompt(prompt: indices![0] as! String)
      }, cancel: nil, origin: self.view)
    }
  }
  
  @IBAction func promptChanged(_ sender: AnyObject) {
    ResponseModel.setPrompt(index: index, prompt: customPrompt.text ?? "")
    updateNextButton()
  }
  
  func textViewDidChange(_ textView:UITextView) {
    ResponseModel.setResponse(index: index, response: response.text)
    updateNextButton()
    response.scrollRangeToVisible(response.selectedRange)
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range:NSRange, replacementText text:String) -> Bool {
//  func textView(textView: UITextView, shouldChangeTextIn range: NSRange, replacementText replacement: String) -> Bool {
    let currentText = response.text as NSString
    let updatedText = currentText.replacingCharacters(in: range, with: text)
    if updatedText.isEmpty || updatedText == "Write response here..." {
      response.text = "Write response here..."
      response.textColor = UIColor.lightGray
      response.selectedTextRange = response.textRange(from: response.beginningOfDocument, to: response.beginningOfDocument)
      return false
    } else if textView.textColor == UIColor.lightGray && !updatedText.isEmpty {
      textView.text = ""
      textView.textColor = UIColor.black
    }
    
    return true
  }
  
  func textViewDidChangeSelection(_ textView: UITextView) {
    if self.view.window != nil {
      let firstPosition = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
      if (response.selectedRange.location == 0) {
        return
      }
      if response.textColor == UIColor.lightGray && response.selectedRange.location != 0 {
        response.selectedTextRange = firstPosition
      }
    }
  }
  
  func updateNextButton() {
    let enabled = response.text.count > 10 && (!promptLabel.isHidden || customPrompt.text!.count > 0)
    self.navigationItem.rightBarButtonItem!.isEnabled = enabled;
  }
  
  func setPrompt(prompt:String) {
    if prompt == "Custom Prompt" {
      customPrompt.isHidden = false
      customPrompt.text = ""
      promptLabel.isHidden = true
      ResponseModel.setPrompt(index: index, prompt: "")
    } else {
      promptLabel.isHidden = false
      promptLabel.text = prompt
      customPrompt.isHidden = true
      ResponseModel.setPrompt(index: index, prompt: prompt)
    }
  }
  
  @IBAction func addMention(_ sender: AnyObject) {
    selectMention()
  }
  
  func selectMention() {
    dismissKeyboard()
    if let users = users {
      var rows = users.map { $0.name }
      rows.insert("Select Contact...", at: 0)
      rows.insert("Enter Email...", at: 0)
      ActionSheetMultipleStringPicker.show(withTitle: "Select ", rows: [rows], initialSelection: [0], doneBlock: {_,values,indices in
        // TODO: Fix me
//        let selected = indices[0] as! String
//        if (selected == "Select Contact...") {
//          let picker = ABPeoplePickerNavigationController()
//          picker.peoplePickerDelegate = self;
//          self.present(picker, animated: true, completion: nil);
//          return
//        } else if (selected == "Enter Email...") {
//          self.createEmailAlert()
//          return
//        }
//        for tagView in self.mentions.tagViews {
//          if (tagView.titleLabel!.text! == selected) { return }
//        }
//
//        var view = self.mentions.addTag(selected)
//        view.accessibilityIdentifier = String(users[values[0]as! Int - 2].id)
//        if let imageData = ImagesCache.sharedInstance.images[view.tag] {
//          view.image.image = imageData
//        }
//        self.updateMentions()
        
      }, cancel: nil, origin: self.view)
    }
  }
  
  func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
    for tag in mentions.tagViews { tag.isSelected = false }
    tagView.isSelected = true
    selectMention()
  }
  
  func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void {
    mentions.removeTag(title)
    updateMentions()
  }
  
  func updateMentions() {
    var ids:[String] = []
    for tagView in self.mentions.tagViews {
      ids.append(tagView.accessibilityIdentifier!)
    }
    ResponseModel.setMentions(index: index, mentions:ids)
    mentionsPlaceholder.isHidden = self.mentions.tagViews.count > 0
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nextButton = UIBarButtonItem.init(title: "Next", style: .plain, target: self, action: Selector(("gotoNext")))
    nextButton.isEnabled = false
    
    nextButton.tintColor = UIColor.white
    nextButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white], for: [])
    nextButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 16)!, NSAttributedStringKey.foregroundColor: DISABLED_COLOR], for: .disabled)
    self.navigationItem.rightBarButtonItem = nextButton
    self.navigationItem.title = "Write"
    
    let borderColor = UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0)
    mentions.superview?.addBottomBorderWithColor(color: borderColor, width: 1)
    mentions.superview?.addTopBorderWithColor(color: UIColor(red:95/255.0, green:202/255.0, blue:237/255.0, alpha: 1.0), width: 1)
    
    let tap = UITapGestureRecognizer(target: self, action: Selector(("selectMention")))
    mentions.addGestureRecognizer(tap)
    mentions.delegate = self
    
    promptLabel.isHidden = true
    
    if let _ = response.text?.isEmpty {
      response.text = "Write response here..."
      response.textColor = UIColor.lightGray
      response.selectedTextRange = response.textRange(from: response.beginningOfDocument, to: response.beginningOfDocument)
      response.contentInset = UIEdgeInsetsMake(-4,-4,0,0);
    }
    
    mentionButton.layer.borderColor = APP_COLOR.cgColor
    
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    
    let buttonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    buttonItem.tintColor = UIColor.white
    self.navigationController?.navigationBar.backItem?.title = "";
  }
  
  override func viewDidAppear(_ animated:Bool) {
    super.viewDidAppear(animated)
    promptNumber.text = "Prompt \(index + 1) of 3"
    
    if let currentPrompt = currentPrompt {
      setPrompt(prompt: currentPrompt)
    }
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
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
    let alertController = UIAlertController(title: "Add Mention", message: "An invite will be sent to the following email after your response is published.", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      let emailField = alertController.textFields![0]
      if let email = emailField.text {
        let view = self.mentions.addTag(email)
        view.accessibilityIdentifier = String(email)
        self.updateMentions()
      }
    }
    alertController.addAction(OKAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      
    }
    alertController.addAction(cancelAction)
    alertController.addTextField { textField in
      textField.placeholder = "Email"
      textField.keyboardType = UIKeyboardType.emailAddress
      NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
        OKAction.isEnabled = textField.text != ""
      }
    }
    self.present(alertController, animated: true, completion: nil)
  }
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
    let list: ABMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty).takeRetainedValue() //
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
    border.backgroundColor = color.cgColor
    border.frame = CGRect.init(x: -20, y: 0, width: self.frame.size.width, height: width)
    self.layer.addSublayer(border)
  }
  
  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect.init(x: -20, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
    self.layer.addSublayer(border)
  }
}
