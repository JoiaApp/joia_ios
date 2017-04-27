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
  var sortedKeys:Array<String>?
  var dataSorted:Array<Array<Response>>?
  
  @IBOutlet var table: UITableView!
  
  override func viewDidLoad() {
    tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.allowsSelection = false
    super.viewDidLoad();
    
    self.navigationController?.navigationBar.titleTextAttributes =  [NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 16)!, NSForegroundColorAttributeName: UIColor.whiteColor()];
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
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        return dateFormatter.stringFromDate(response.date!)
      }
      // Get the keys and sort them
      self.sortedKeys = data?.keys.sort().reverse()
      self.dataSorted = Array<Array<Response>>()
      for key in self.sortedKeys! {
        self.dataSorted!.append(data![key]!)
      }
      self.tableView.reloadData()
    }
    responseModel.getThread(GroupModel.getCurrentGroup()!)
  }
  
  override func numberOfSectionsInTableView(_:UITableView) -> Int {
    guard let _ = self.dataSorted else {
      return 0
    }
    return self.dataSorted!.count
  }

  override func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section < self.dataSorted!.count {
      return self.dataSorted![section].count
    } else {
      return 0
    }
  }
  
  override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let _ = self.sortedKeys else {
      return nil
    }
    
    let view = UIView.init(frame: CGRectMake(0, 0, tableView.frame.width, 20));
    let label = UILabel.init(frame: CGRectMake(16, 8, tableView.frame.width, 20));
    label.font = UIFont.init(name: "OpenSans", size: 12)!
    label.textColor = UIColor.lightGrayColor()
    view.backgroundColor = UIColor.whiteColor()
    let dateString = self.sortedKeys![section]
    
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    let date = dateFormatter.dateFromString(dateString)
    label.text = ResponseModel.relativeDateStringForDate(date!) as String
    
    view.addSubview(label)
    return view;
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let response = self.dataSorted![indexPath.section][indexPath.row]
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