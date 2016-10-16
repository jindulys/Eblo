//
//  TableViewManager+EBRealmCompanyManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-16.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import SiYuanKit

extension TableViewManager: EBRealmCompanyManagerDelegate {
  func hasNewDataSet() {
    self.refreshData()
  }
}
