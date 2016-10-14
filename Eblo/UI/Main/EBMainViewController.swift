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
		self.view.backgroundColor = UIColor.yellow
	}
}
