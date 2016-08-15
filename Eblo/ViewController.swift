//
//  ViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-07-30.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

class ViewController: UIViewController {
  
  var tableView: UITableView = UITableView()
  
  let tableManager: TableViewManager = TableViewManager()
  
  override func loadView() {
    super.loadView()
    self.view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white()
    tableManager.tableView = tableView
    tableView.estimatedRowHeight = 40
    let row1:Row = Row(title:"Hello World" ,
                       description:"World is big",
                       cellType: ItemCell.self,
                       image: nil, action: {
                         print("Log out")
                       },
                       cellIdentifier: "item")
    
    let row2 = Row(title: "Swift", description: "This is a quite long sentence and i hope that this sentence could be truncated if needed, this means that I could happily go to sleep without any worries", cellType: ItemCell.self, cellIdentifier: "item")
    
    let testRows = [row1, row2]
    tableManager.data = .SingleSection(testRows)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

