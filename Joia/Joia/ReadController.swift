//
//  ReadController.swift
//  Joia
//
//  Created by Josh Bodily on 11/15/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class ReadController : UITableViewController {
  
  var responses:Array<Response>?
  @IBOutlet var table: UITableView!
  
  override func viewDidLoad() {
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    super.viewDidLoad();
  }
  
  override func viewDidAppear(animated: Bool) {
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
    
    let responseModel = ResponseModel()
    responseModel.success { (_, model:AnyObject?) -> Void in
      self.responses = model as? Array<Response>
      self.tableView.reloadData()
    }
    responseModel.getThread(GroupModel.getCurrentGroup()!)
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let thread = responses {
      return thread.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let response = responses![indexPath.row]
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! EntryTableViewCell
    cell.response = response
    return cell
  }
  
}