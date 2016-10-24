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
    EBRealmCompanyManager.sharedInstance.writeWithLocalFile()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.testJi()
//    let testBlog = EBBlog()
//    testBlog.blogTitle = "Yelp Test"
//    testBlog.blogURL = "Yelp URL"
//    EBRealmCompanyManager.sharedInstance.updateCompanyWith(UUID:"Yelphttp://engineeringblog.yelp.com/", blogInfos: [testBlog])
  }

  override func viewDidAppear(_ animated: Bool) {
    //EBRealmCompanyManager.sharedInstance.deleteAllCompanies()
    tableManager.refreshData()
  }
  
  func addNewRecord() {
    self.navigationController?.pushViewController(EBEditRecordViewController(), animated: true)
  }
  
  func testJi() {
    let testDoc = Ji(htmlURL: URL(string: "http://tech.gilt.com/")!)
    //let titleNode = testDoc?.xPath("//article//h3//a")
    //let titleNode = testDoc?.xPath("/html//article//h3//a | /html//article//div[@class='post-preview']//a/@href")
    let testNode = testDoc?.xPath("//*[@id='main']/div[2]/div/article[2]/h1/a")
    for t in testNode! {
      print("\(t.content)")
    }
//    for title in titleNode! {
//      print("\(title.content)")
//    }
  }
}
