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
    
    let buttonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    buttonItem.tintColor = UIColor.white
    self.navigationItem.backBarButtonItem = buttonItem
    
    self.navigationController?.navigationBar.titleTextAttributes =  [NSAttributedStringKey.font: UIFont(name: "OpenSans-Semibold", size: 16)!, NSAttributedStringKey.foregroundColor: UIColor.white];
    self.navigationController?.navigationBar.tintColor = UIColor.white;
  }
  
  override  func tableView(_ tableView: UITableView, didSelectRowAt
  indexPath: IndexPath) {
    
    switch indexPath.row {
    case 0:
      self.performSegue(withIdentifier: "gotoProfile", sender: self)
    case 1:
      self.performSegue(withIdentifier: "gotoGroupSettings", sender: self)
    case 2:
      self.performSegue(withIdentifier: "gotoTermsAndConditions", sender: self)
    case 4:
      UserModel().logout();
      let landingController = self.storyboard?.instantiateViewController(withIdentifier: "Landing") as? LandingController
      self.present(landingController!, animated: true, completion: nil)
    default:
      print("Unrecognized setting selected");
    }
  }
}
