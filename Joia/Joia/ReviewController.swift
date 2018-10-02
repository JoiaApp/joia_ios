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
    tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.allowsSelection = false
    super.viewDidLoad();
    
    let nextButton = UIBarButtonItem.init(title: "Publish", style: .plain, target: self, action: Selector.init("publish"))
    self.navigationItem.rightBarButtonItem = nextButton
  }
  
  func publish() {
    let user = UserModel.getCurrentUser()
    let group = GroupModel.getCurrentGroup()
    if (ResponseModel().publishResponses(group: group!, user: user!)) {
      self.tabBarController?.selectedIndex = 0 // go to Journal
      ResponseModel.composing = false
    } else {
      let alert = UIAlertController(title: "Oops", message: "Something went wrong, please try again later.", preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        
      }
      alert.addAction(OKAction)
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user = UserModel.getCurrentUser()
    let unpublishedResponse = ResponseModel.getTempResponse(index: indexPath.row)!
    let response = Response.init(text: unpublishedResponse.response!, prompt: unpublishedResponse.prompt!, user: user, mentions:[])
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EntryTableViewCell
    cell.response = response
    return cell
  }
  
}
