//
//  ReviewController.swift
//  Joia
//
//  Created by Josh Bodily on 11/15/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class ReviewController : UITableViewController {
  
  var responses:Array<Response>?
  @IBOutlet var table: UITableView!
  
  override func viewDidLoad() {
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.allowsSelection = false
    super.viewDidLoad();
    
    let nextButton = UIBarButtonItem.init(title: "Publish", style: .Plain, target: self, action: Selector("publish"))
    self.navigationItem.rightBarButtonItem = nextButton
  }
  
  func publish() {
    let user = UserModel.getCurrentUser()
    let group = GroupModel.getCurrentGroup()
    if (ResponseModel().publishResponses(group!, user: user!)) {
      self.tabBarController?.selectedIndex = 0 // go to Journal
      ResponseModel.composing = false
    } else {
      let alert = UIAlertController(title: "Oops", message: "Something went wrong, please try again later.", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
        
      }
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let user = UserModel.getCurrentUser()
    let unpublishedResponse = ResponseModel.getTempResponse(indexPath.row)!
    let response = Response.init(text: unpublishedResponse.response!, prompt: unpublishedResponse.prompt!, user: user, mentions:[])
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! EntryTableViewCell
    cell.response = response
    return cell
  }
  
}