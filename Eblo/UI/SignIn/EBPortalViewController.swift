//
//  File.swift
//  Eblo
//
//  Created by yansong li on 2016-08-19.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

/// Portal View Controller is responsible for User login/signup.
class EBPortalViewController: UIViewController {
  override func viewDidLoad() {
    self.view.backgroundColor = UIColor.blue()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    GCDQueue.main.after(when: 1.2) { 
      AppManager.sharedInstance.goToMainWith(URI: nil)
    }
  }
}
