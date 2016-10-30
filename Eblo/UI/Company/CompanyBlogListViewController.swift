//
//  CompanyBlogListViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-30.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SafariServices
import SiYuanKit
import UIKit

/// The view controller for a company to show a list of blogs.
class CompanyBlogListViewController: UIViewController {
  /// TableView managed by this view controller.
  var tableView: UITableView = UITableView()

  /// The tableview manager, who is responsible for update of table view.
  let tableManager: TableViewManager = TableViewManager()

  /// The company's UUID.
  let companyUUID: String

  /// The company for this view controller.
  var company: Company?

  init(companyUUID: String) {
    self.companyUUID = companyUUID
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    self.view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.company = RealmCompanyManager.sharedInstance.companyWith(UUID: self.companyUUID)
    self.title = self.company?.companyName

    // 1. Set tableView property on for tableManager. so view controller could use its lower
    // level (tableManager) to manage the tableView's events.
    tableManager.tableView = self.tableView
    // Set estimatedRowHeight if you want to get a variant height.
    tableView.estimatedRowHeight = 40
    // 2. Set tableManager's dataSource to its lower level to get the data.
    tableManager.dataSource = RealmBlogManager.sharedInstance
    // 3. Set dataSource's subscriber to its upper level to initiatively report data change.
    RealmBlogManager.sharedInstance.subscriber = tableManager
    RealmBlogManager.sharedInstance.uiDelegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }

  override func viewDidAppear(_ animated: Bool) {
    tableManager.refreshData()
  }
}

extension CompanyBlogListViewController: TransitionViewController {
  var sourceScreenName: String {
    return String(describing:type(of: self))
  }
}

extension CompanyBlogListViewController: RealmBlogManagerUIDelegate {
  /// Tell the UI Delegate that row was tapped with necessary info.
  func tappedRow(blogURLString: String) {
    let svc = SFSafariViewController(url: NSURL(string: blogURLString)! as URL)
    svc.title = self.company?.companyName
    AppManager.sharedInstance.presentToNavTop(controller: svc)
  }

  /// The blogs.
  func blogs() -> List<CompanyBlog>? {
    return self.company?.blogs
  }
}
