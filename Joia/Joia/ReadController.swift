//
//  ReadController.swift
//  Joia
//
//  Created by Josh Bodily on 11/15/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class ReadController : UITableViewController {
  
  var responses:Array<Response>?
  @IBOutlet var table: UITableView!
  
  override func viewDidLoad() {
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.allowsSelection = false
    super.viewDidLoad();
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    guard let _ = GroupModel.getCurrentGroup() else {
      let alert = UIAlertController(title: "No group selected", message: "Please select a group", preferredStyle: .Alert)
      let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
        self.tabBarController?.selectedIndex = GROUPS_INDEX
      }
      alert.addAction(OKAction)
      self.presentViewController(alert, animated: true, completion: nil)
      return
    }
    
    let responseModel = ResponseModel()
    responseModel.success { (_, model:AnyObject?) -> Void in
      self.responses = model as? Array<Response>
      let data = self.responses?.categorise { (response:Response) -> String in
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = NSTimeZone.init(name: "UTC")
        return dateFormatter.stringFromDate(response.date!)
      }
      // Get the keys and sort them
      let sortedKeys = data?.keys.sort()
      var dataSorted = Array<Array<Response>>()
      for key in sortedKeys! {
        dataSorted.append(data![key]!)
      }
      self.tableView.reloadData()
    }
    responseModel.getThread(GroupModel.getCurrentGroup()!)
  }
  
  override func numberOfSectionsInTableView(_:UITableView) -> Int {
    return 1
  }
  
  // There is just one row in every section
  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let responses = self.responses {
      return responses.count
    } else {
      return 0
    }
  }
  
  // Set the spacing between sections
  override func tableView(_ : UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 0
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let response = responses![indexPath.section]
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! EntryTableViewCell
    cell.response = response
    return cell
  }
}

public extension SequenceType {
  // Categorises elements of self into a dictionary, with the keys given by keyFunc
  func categorise<U : Hashable>(@noescape keyFunc: Generator.Element -> U) -> [U:[Generator.Element]] {
    var dict: [U:[Generator.Element]] = [:]
    for el in self {
      let key = keyFunc(el)
      if case nil = dict[key]?.append(el) { dict[key] = [el] }
    }
    return dict
  }
}