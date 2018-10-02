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
    tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.allowsSelection = false
    super.viewDidLoad();
    
    self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "OpenSans-Semibold", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white];
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let _ = GroupModel.getCurrentGroup() else {
      let alert = UIAlertController(title: "No group selected", message: "Please select a group", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        self.tabBarController?.selectedIndex = GROUPS_INDEX
      }
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    let responseModel = ResponseModel()
    responseModel.success { (_, model:AnyObject?) -> Void in
      self.responses = model as? Array<Response>
      let data = self.responses?.categorise { (response:Response) -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: response.date!)
      }
      // Get the keys and sort them
      self.sortedKeys = data?.keys.sorted().reversed()
      self.dataSorted = Array<Array<Response>>()
      for key in self.sortedKeys! {
        self.dataSorted!.append(data![key]!)
      }
      self.tableView.reloadData()
    }
    responseModel.getThread(group: GroupModel.getCurrentGroup()!)
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
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
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let _ = self.sortedKeys else {
      return nil
    }
    
    let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20));
    let label = UILabel.init(frame: CGRect(x: 16, y: 8, width: tableView.frame.width, height: 20));
    label.font = UIFont.init(name: "OpenSans", size: 12)!
    label.textColor = UIColor.lightGray
    view.backgroundColor = UIColor.white
    let dateString = self.sortedKeys![section]
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd"
    dateFormatter.timeZone = NSTimeZone.local
    let date = dateFormatter.date(from: dateString)
    label.text = ResponseModel.relativeDateStringForDate(date: date!) as String
    
    view.addSubview(label)
    return view;
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let response = self.dataSorted![indexPath.section][indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EntryTableViewCell
    cell.response = response
    return cell
  }
}

public extension Sequence {
  // Categorises elements of self into a dictionary, with the keys given by keyFunc
  func categorise<U : Hashable>( keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
    var dict: [U:[Iterator.Element]] = [:]
    for el in self {
      let key = keyFunc(el)
      if case nil = dict[key]?.append(el) { dict[key] = [el] }
    }
    return dict
  }
}
