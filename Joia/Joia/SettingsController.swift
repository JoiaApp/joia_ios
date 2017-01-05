//
//  SettingsController.swift
//  Joia
//
//  Created by Josh Bodily on 10/30/16.
//  Copyright © 2016 Joia. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {
  
  @IBOutlet var table: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad();
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.row {
    case 0:
      self.performSegueWithIdentifier("gotoProfile", sender: self)
    case 1:
      self.performSegueWithIdentifier("gotoGroupSettings", sender: self)
    case 2:
      self.performSegueWithIdentifier("gotoTermsAndConditions", sender: self)
    case 4:
      UserModel().logout();
      let landingController = self.storyboard?.instantiateViewControllerWithIdentifier("Landing") as? LandingController
      self.presentViewController(landingController!, animated: true, completion: nil)
    default:
      print("Unrecognized setting selected");
    }
  }
}
