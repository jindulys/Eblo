//
//  TableViewManager.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

#if os(iOS)

/// A Protocol Defines a data source that provides data to display for this tableViewManager.
public protocol TableViewManagerDataSource: class {
  /// The data that is needed by a tableViewManager.
  func fetchedData() -> TableViewData
}

/// Representation of the style of tableViewData.
public enum TableViewData {
  case SingleSection([Row])
  case MultiSection([Section])
}

/// Manager to handle TableView related events.
open class TableViewManager: NSObject {
  
  /// The Identifiers registered to the `tableView`.
  public var registeredCellIdentifiers: [String] = []

  /// The potential data source that provide data to this table view manager.
  public weak var dataSource: TableViewManagerDataSource?
  
  /// This is used to control whether or not we will refresh data when new data comes.
  /// This variable existing because we have two ways to refresh Table.
  /// The first one is when data is set
  /// The second one is when rows get stale and need updateStaledRows.
  public var banRefreshTableWhenNewDataCome: Bool = false

  /**
    tableView object managed by this Manager.
   */
  public var tableView: UITableView? {
    willSet {
      registeredCellIdentifiers = []
    }
    didSet {
      tableView?.delegate = self
      tableView?.dataSource = self
      refreshTableView()
    }
  }
  
  /// The data for this tableViewManager.
  public var data: TableViewData = .SingleSection([]) {
    didSet {
      dataValueUpdate(from: oldValue, to: data)
    }
  }
  
  /// This method will be called every time the data of this tableViewManager changed.
  /// SubClass could subclass this method to get the entry point to configure the data.
  /// MUST CALL SUPER.
  open func dataValueUpdate(from: TableViewData?, to: TableViewData?) {
    if !banRefreshTableWhenNewDataCome {
      refreshTableView(oldData: from)
    }
  }

  /// Require this table view manager to refresh its data.
  public func refreshData() {
    guard let dataSource = dataSource else {
      return
    }
    self.data = dataSource.fetchedData()
  }
}

// MARK: Helpers
extension TableViewManager {

  /// Reload tableView and register cell.
  fileprivate func refreshTableView(oldData: TableViewData? = nil) {
    refreshRegisteredCells()
    updateTableViewLayout(oldData: oldData)
  }

  private func updateTableViewLayout(oldData: TableViewData? = nil) {
    guard let old = oldData else {
      tableView?.reloadData()
      return
    }
    switch (old, data) {
    case (.MultiSection(let oldSections),
          .MultiSection(let newSections)):
      let oldCount = oldSections.count
      let newCount = newSections.count
      let delta = newCount - oldCount

      tableView?.beginUpdates()
      if delta == 0 {
        tableView?.reloadSections(IndexSet(integersIn: 0..<newCount), with: .automatic)
      } else {
        if delta > 0 {
          tableView?.insertSections(IndexSet(integersIn: oldCount..<newCount),
                                    with: .fade)
        } else {
          tableView?.deleteSections(IndexSet(integersIn: newCount..<oldCount), with: .right)
        }
        let commonCount = min(oldCount, newCount)
        tableView?.reloadSections(IndexSet(integersIn: 0..<commonCount), with: .fade)
      }
      tableView?.endUpdates()
    case (.SingleSection(let oldRows),
          .SingleSection(let newRows)):
      let oldRowsCount = oldRows.count
      let newRowsCount = newRows.count
      let delta = newRowsCount - oldRowsCount

      tableView?.beginUpdates()
      if delta == 0 {
        var needUpdatedIndexPaths: [IndexPath] = []
        for i in 0..<oldRowsCount {
          needUpdatedIndexPaths.append(IndexPath(row: i, section: 0))
        }
        tableView?.reloadRows(at: needUpdatedIndexPaths, with: .automatic)
      } else {
        if delta > 0 {
          var needInsertedIndexPaths: [IndexPath] = []
          for i in oldRowsCount..<newRowsCount {
            needInsertedIndexPaths.append(IndexPath(row: i, section: 0))
          }
          tableView?.insertRows(at: needInsertedIndexPaths, with: .fade)
        } else {
          var needDeletedIndexPaths: [IndexPath] = []
          for i in newRowsCount..<oldRowsCount {
            needDeletedIndexPaths.append(IndexPath(row: i, section: 0))
          }
          tableView?.deleteRows(at: needDeletedIndexPaths, with: .right)
        }
        let commonCount = min(oldRowsCount, newRowsCount)
        var needReloadedIndexPaths: [IndexPath] = []
        for i in 0..<commonCount {
          needReloadedIndexPaths.append(IndexPath(row: i, section: 0))
        }
        tableView?.reloadRows(at: needReloadedIndexPaths, with: .automatic)
      }
      tableView?.endUpdates()
    default:
      tableView?.reloadData()
    }
  }

  /// Reload the staled rows once your data get stale and need refresh.
  public func updateStaledRows(byReloadTableData reload: Bool = false) {
    switch data {
    case .SingleSection(var rows):
      var staledRowIndexPaths: [IndexPath] = []
      /// NOTE: this is important, we need this newRows to get the new state change, and assign it back
      /// The reason is that self.data is a enum and it is a value type.
      var newRows: [Row] = rows
      for i in 0..<rows.count {
        if rows[i].getStale {
          staledRowIndexPaths.append(IndexPath(row: i, section: 0))
          newRows[i].getStale = false
        }
      }
      // NOTE: set the ban refresh flag on so that we could ban the update from the data and only
      // use update animation for the get stale one.
      self.banRefreshTableWhenNewDataCome = true
      self.data = .SingleSection(newRows)
      self.banRefreshTableWhenNewDataCome = false

      if staledRowIndexPaths.count == 0 {
        break
      }
      if !reload {
        tableView?.beginUpdates()
        tableView?.reloadRows(at: staledRowIndexPaths, with: .fade)
        tableView?.endUpdates()
      } else {
        tableView?.reloadData()
      }
    case .MultiSection(var sections):
      var staledRowIndexPaths: [IndexPath] = []
      for i in 0..<sections.count {
        for j in 0..<sections[i].rows.count {
          if sections[i].rows[j].getStale {
            staledRowIndexPaths.append(IndexPath(row: j, section: i))
            sections[i].rows[j].getStale = false
          }
        }
      }
      if staledRowIndexPaths.count == 0 {
        break
      }
      if !reload {
        tableView?.beginUpdates()
        tableView?.reloadRows(at: staledRowIndexPaths, with: .fade)
        tableView?.endUpdates()
      } else {
        tableView?.reloadData()
      }
      break
    }
  }

  private func refreshRegisteredCells() {
    var rows: [Row] = []
    switch data {
    case .SingleSection(let r):
      rows = r.filter { !self.registeredCellIdentifiers.contains($0.cellIdentifier) }
    case .MultiSection(let s):
      rows = s.flatMap { $0.rows }.filter {
        !self.registeredCellIdentifiers.contains($0.cellIdentifier)
      }
    }
    rows.forEach { (row) in
      if self.registeredCellIdentifiers.contains(row.cellIdentifier) {
        return
      }
      self.registeredCellIdentifiers.append(row.cellIdentifier)
      self.tableView?.register(row.cellType, forCellReuseIdentifier: row.cellIdentifier)
    }
  }
  
  /// Return row for specified index.
  fileprivate func rowForIndexPath(_ index: IndexPath) -> Row? {
    switch data {
    case .SingleSection(let r):
      if r.count > index.row {
        return r[index.row]
      }
    case .MultiSection(let s):
      if s.count > index.section {
        let selectSection = s[index.section]
        if selectSection.rows.count > index.row {
          return selectSection.rows[index.row]
        }
      }
    }
    return nil
  }
}

extension TableViewManager: UITableViewDataSource {
  
  open func tableView(_ tableView: UITableView,
      numberOfRowsInSection section: Int) -> Int {
    switch data {
    case .SingleSection(let r):
      return r.count
    case .MultiSection(let s):
      return s[section].rows.count
    }
  }
  
  open func numberOfSections(in tableView: UITableView) -> Int {
    switch data {
    case .SingleSection(_):
      return 1
    case .MultiSection(let s):
      return s.count
    }
  }
  
  open func tableView(_ tableView: UITableView,
             cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let row = rowForIndexPath(indexPath) {
      let cell = tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier,
                                                          for: indexPath)
      if let staticCell = cell as? StaticCellType {
        staticCell.configure(row: row)
      }
      return cell
    }
    return UITableViewCell()
  }
  
  open func tableView(_ tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
    switch data {
    case .SingleSection(_):
      return nil
    case .MultiSection(let s):
      return s[section].title
    }
  }
  
  open func tableView(_ tableView: UITableView,
   heightForHeaderInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  open func tableView(_ tableView: UITableView,
   heightForFooterInSection section: Int) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  open func tableView(_ tableView: UITableView,
    titleForFooterInSection section: Int) -> String? {
    return nil
  }
}

extension TableViewManager: UITableViewDelegate {
  open func tableView(_ tableView: UITableView,
           didSelectRowAt indexPath: IndexPath) {
    if let row = self.rowForIndexPath(indexPath) {
      row.action?()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

#endif
