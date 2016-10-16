//
//  MainViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-14.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

class EBMainViewController: UIViewController {
	var tableView: UITableView = UITableView()
	
	let tableManager: TableViewManager = TableViewManager()
	
	override func loadView() {
		super.loadView()
		self.view = tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecord))
    self.navigationItem.backBarButtonItem =
      UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let myCurrentCompanies = EBRealmManager.sharedInstance.allCompanies()
    if let c = myCurrentCompanies {
      print(c.count)
    }
    EBRealmManager.sharedInstance.deleteAllCompanies()
  }
  
  func addNewRecord() {
    print("Add a new record")
    self.navigationController?.pushViewController(EBEditRecordViewController(), animated: true)
  }
}
