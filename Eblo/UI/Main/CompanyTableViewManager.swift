//
//  CompanyTableManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-27.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import SiYuanKit

/// CompanyTableViewManager which is responsible the management of a tableView related to company data.
class CompanyTableViewManager: TableViewManager {

  /// Register KVO
  open override func dataValueUpdate(from: TableViewData?, to: TableViewData?) {
    super.dataValueUpdate(from: from, to: to)
    // Add observer
    let fromData = from ?? .SingleSection([])
    let toData = to ?? .SingleSection([])
    switch (fromData, toData) {
    case (.SingleSection(let fromRows),
          .SingleSection(let toRows)):
      // NOTE: Important, what I learned is that realm object you should KVO the latest object, so
      // every time we get new data, we just KVO all new ones and remove old ones.
      fromRows.forEach {
        if let company = $0.customData as? Company {
          company.removeObserver(self, forKeyPath: "hasNewArticlesToRead")
          company.removeObserver(self, forKeyPath: "latestArticleTitle")
        }
      }
      toRows.forEach {
        if let company = $0.customData as? Company {
          company.addObserver(self, forKeyPath: "hasNewArticlesToRead", options: [.new, .old], context: nil)
          company.addObserver(self, forKeyPath: "latestArticleTitle", options: .new, context: nil)
        }
      }
      break
    default:
      print("Should not be this case")
    }
  }

  deinit {
    switch data {
    case .SingleSection(let rows):
      rows.forEach {
        if let company = $0.customData as? Company {
          company.removeObserver(self, forKeyPath: "hasNewArticlesToRead")
          company.removeObserver(self, forKeyPath: "latestArticleTitle")
        }
      }
    default:
      print("Should not be this case")
    }
  }
  
  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
    if let changedCompany = object as? Company {
      if keyPath == "hasNewArticlesToRead",
        let newValue = change?[.newKey] as? Bool,
        let oldValue = change?[.oldKey] as? Bool,
        newValue == oldValue {
        return
      }
      switch data {
      case .SingleSection(let rows):
        var newRows: [Row] = rows
        for i in 0..<rows.count {
          if let currentCompany = rows[i].customData as? Company, currentCompany == changedCompany {
            newRows[i].getStale = true
            break
          }
        }
        // NOTE: set the ban refresh flag on so that we could ban the update from the data and only
        // use update animation for the get stale one.
        self.banRefreshTableWhenNewDataCome = true
        self.data = .SingleSection(newRows)
        if keyPath == "hasNewArticlesToRead",
          let newValue = change?[.newKey] as? Bool, newValue == false {
          // NOTE: Instead of use reloadRow. Use tableView.reloadData directly.
          self.updateStaledRows(byReloadTableData: true)
        } else {
          self.updateStaledRows()
        }
        self.banRefreshTableWhenNewDataCome = false
      default:
        print("Should not be this case")
      }
    }
  }
}
