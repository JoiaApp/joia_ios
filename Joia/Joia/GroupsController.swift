//
//  GroupsController.swift
//  Joia
//
//  Created by Josh Bodily on 11/16/16.
//  Copyright © 2016 Josh Bodily. All rights reserved.
//

import UIKit

class GroupsController : UITableViewController {
  
  var groups:Array<Group>?
  
  override func viewDidLoad() {
    super.viewDidLoad();
    let groupsModel = GroupModel()
    if let user = UserModel.getCurrentUser() {
      groupsModel.getAll(user)
    } else {
      
    }
    groupsModel.success { (message:String?, model:AnyObject?) -> Void in
      self.groups = model as! Array<Group>
      self.tableView.reloadData()
    }
    groupsModel.error { (message:String?) -> Void in
      let alert = UIAlertController(title: "Oops", message: message ?? "Something went wrong", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        
      }
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
    }
    
    let alert = UIAlertController(title: "Select group", message: "Select current group", preferredStyle: .Alert)
    let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
      
    }
    alert.addAction(OKAction)
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let groups = groups {
      return groups.count
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
    let group = groups![indexPath.row]
    cell.textLabel!.text = group.name
    if let currentGroup = GroupModel.getCurrentGroup() where currentGroup.guid == group.guid  {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let groups = groups {
      let group = groups[indexPath.row]
      let alert = UIAlertController(title: "Select group?", message: "Set \(group.name) as your current group", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "Confirm", style: .Default) { (action) in
        GroupModel.setCurrentGroup(group)
        tableView.reloadData()
      }
      let DismissAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        
      }
      alert.addAction(DismissAction)
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
    }
  }
}
