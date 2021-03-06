//
//  MainViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-14.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Crashlytics
import Ji
import SiYuanKit
import UIKit

class MainViewController: UIViewController {
	var tableView: UITableView = UITableView()
	
	let tableManager: CompanyTableViewManager = CompanyTableViewManager()
	
	override func loadView() {
		super.loadView()
		self.view = tableView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
    self.title = "Old Eng Blogs"
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(functionTest))
    self.navigationItem.leftBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearAllNewArticles))
    self.navigationItem.backBarButtonItem =
      UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
    // 1. Set tableView property on for tableManager. so view controller could use its lower
    // level (tableManager) to manage the tableView's events.
    tableManager.tableView = self.tableView
    // Set estimatedRowHeight if you want to get a variant height.
    tableView.estimatedRowHeight = 40
    // 2. Set tableManager's dataSource to its lower level to get the data.
    tableManager.dataSource = RealmCompanyManager.sharedInstance
    // 3. Set dataSource's subscriber to its upper level to initiatively report data change.
    RealmCompanyManager.sharedInstance.subscriber = tableManager
    RealmCompanyManager.sharedInstance.uiDelegate = self

    // TODO(simonli): might need to remove this one.
    RealmCompanyManager.sharedInstance.repeatedWriteWithLocalFile {
      GCDQueue.main.async {
        self.tableManager.refreshData()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  func clearAllNewArticles() {
    RealmCompanyManager.sharedInstance.clearAllNewArticlesFlag()
    //testJi()
  }
  
  func functionTest() {
    // TEST: screenTransition manager.
    ScreenTransitionManager.transitionScreenWith(viewController: self, entryPoint: self.editRecordEntry)
  }

  func testJi() {
    let testDoc = Ji(htmlURL: URL(string: "https://tech.just-eat.com/")!)
    //let titleNode = testDoc?.xPath("//article//h3//a")
    //let titleNode = testDoc?.xPath("/html//article//h3//a | /html//article//div[@class='post-preview']//a/@href")
    let testNode = testDoc?.xPath("/html/body/main/div[1]/div/div[1]/article/div/div[2]/h2")
    for t in testNode! {
      print("\(t.content)")
    }
    let urlNodes = testDoc?.xPath("/html/body//h3/a/@href")
    for u in urlNodes! {
      print("\(u.content)")
    }
//    for title in titleNode! {
//      print("\(title.content)")
//    }
  }
}

extension MainViewController: TransitionViewController {
  var sourceScreenName: String {
    return String(describing:type(of: self))
  }

  public var companyEntry: String {
    return "companyBlogList"
  }

  public var editRecordEntry: String {
    return "editRecord"
  }
}

extension MainViewController: RealmCompanyManagerUIDelegate {
  func tappedRow(companyUUID: String) {
    print("pressed \(companyUUID)")
    ScreenTransitionManager.transitionScreenWith(viewController: self,
                                                 entryPoint: self.companyEntry,
                                                 params: "uuid=\(companyUUID)")
//    let openURL = company.blogs.first?.blogURL ?? company.blogURL
//    let svc = SFSafariViewController(url: NSURL(string: openURL)! as URL)
//    svc.title = company.companyName
//    AppManager.sharedInstance.presentToNavTop(controller: svc)
  }
}
