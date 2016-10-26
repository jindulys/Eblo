//
//  Row.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

/// The action block to be executed when cell is selected.
public typealias RowAction = () -> ()

/// Row struct represents a data model used for static UITableView.
/// - it will provide information for tableViewCell to render.
/// - it will provide action to perform when tapped. etc.
public struct Row {
  /// UUID for this row.
  public let UUID: String
  /// Title for the cell.
  public let title: String
  /// Description for the cell.
  public let description: String?
  /// Image for the cell.
  public let image: UIImage?
  /// Select action.
  public let action: RowAction?
  /// The cell to be used for display.
  public let cellType: StaticCellType.Type
  /// The identifier to for cell type.
  public let cellIdentifier: String
  /// The customData for this row.
  public let customData: Any?
  
  public init(title: String,
       description: String? = nil,
       image: UIImage? = nil,
       action: RowAction? = nil,
       cellType: StaticCellType.Type = Value1Cell.self,
       cellIdentifier: String = "cell",
       customData: Any? = nil,
       UUID: String = NSUUID().uuidString) {
    self.UUID = UUID
    self.title = title
    self.description = description
    self.image = image
    self.action = action
    self.cellType = cellType
    self.cellIdentifier = cellIdentifier
    self.customData = customData
  }
}

extension Row: Equatable { }

public func ==(lhs: Row, rhs: Row) -> Bool {
  return lhs.UUID == rhs.UUID
}

extension Row: Hashable {
  public var hashValue: Int {
    return UUID.hashValue
  }
}
