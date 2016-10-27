//
//  MainViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-14.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit
import Ji


class EBMainViewController: UIViewController {
	var tableView: UITableView = UITableView()
	
	let tableManager: TableViewManager = TableViewManager()
	
	override func loadView() {
		super.loadView()
		self.view = tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
    self.title = "Eng Blogs"
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewRecord))
    // NOTE: uncomment following when want to test
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(functionTest))
    self.navigationItem.backBarButtonItem =
      UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    // 1. Set tableView property on for tableManager. so view controller could use its lower
    // level (tableManager) to manage the tableView's events.
    tableManager.tableView = self.tableView
    // Set estimatedRowHeight if you want to get a variant height.
    tableView.estimatedRowHeight = 40
    // 2. Set tableManager's dataSource to its lower level to get the data.
    tableManager.dataSource = EBRealmCompanyManager.sharedInstance
    // 3. Set dataSource's subscriber to its upper level to initiatively report data change.
    EBRealmCompanyManager.sharedInstance.subscriber = tableManager

    // TODO(simonli): might need to remove this one.
    EBRealmCompanyManager.sharedInstance.repeatedWriteWithLocalFile()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.testJi()
  }

  override func viewDidAppear(_ animated: Bool) {
    //EBRealmCompanyManager.sharedInstance.deleteAllCompanies()
    tableManager.refreshData()
  }
  
  func addNewRecord() {
    self.navigationController?.pushViewController(EBEditRecordViewController(), animated: true)
  }
  
  func functionTest() {
    EBRealmCompanyManager.sharedInstance.clearAllNewArticlesFlag()
  }

  func testJi() {
    let testDoc = Ji(htmlURL: URL(string: "http://code.flickr.net")!)
    //let titleNode = testDoc?.xPath("//article//h3//a")
    //let titleNode = testDoc?.xPath("/html//article//h3//a | /html//article//div[@class='post-preview']//a/@href")
    let testNode = testDoc?.xPath("/html//article/header/h1/a")
    for t in testNode! {
      print("\(t.content)")
    }
    let urlNodes = testDoc?.xPath("/html//article/header/h1/a/@href")
    for u in urlNodes! {
      print("\(u.content)")
    }
//    for title in titleNode! {
//      print("\(title.content)")
//    }
  }
}
