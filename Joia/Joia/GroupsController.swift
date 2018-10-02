//
//  GroupsController.swift
//  Joia
//
//  Created by Josh Bodily on 11/16/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class GroupsController : UITableViewController {
  
  var groups:Array<Group>?
  
  override func viewDidLoad() {
    super.viewDidLoad();
    self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "OpenSans-Semibold", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white];
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let groupsModel = GroupModel()
    if let user = UserModel.getCurrentUser() {
      groupsModel.success { (message:String?, model:AnyObject?) -> Void in
        self.groups = model as! Array<Group>
        self.tableView.reloadData()
      }
      groupsModel.error { (message:String?) -> Void in
        let alert = UIAlertController(title: "Oops", message: message ?? "Something went wrong", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
          
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
      }
      groupsModel.getAll(user: user)
    } else {
      // Logout ?
    }

    if let _ = GroupModel.currentGroup {
      
    } else {
      let alert = UIAlertController(title: "Select group", message: "Select current group", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        
      }
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let groups = groups {
      return groups.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
    let group = groups![indexPath.row]
    cell.textLabel!.text = group.name
    if let currentGroup = GroupModel.getCurrentGroup(), currentGroup.guid == group.guid  {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let groups = groups {
      let group = groups[indexPath.row]
      let alert = UIAlertController(title: "Select group?", message: "Set \(group.name) as your current group", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
        GroupModel.setCurrentGroup(group: group)
        tableView.reloadData()
      }
      let DismissAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
      }
      alert.addAction(DismissAction)
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
}
