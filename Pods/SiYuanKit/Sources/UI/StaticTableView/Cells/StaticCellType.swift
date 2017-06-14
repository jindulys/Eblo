//
//  StaticCellType.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

#if os(iOS)

/// Protocol used to define the behaviour a cell should have to use `Row`.
public protocol StaticCellType: class {
  
  /// configure a cell with `row`.
  func configure(row: Row)
}

extension StaticCellType where Self: UITableViewCell {
  public func configure(row: Row) {
    textLabel?.text = row.title
    detailTextLabel?.text = row.description
    imageView?.image = row.image
  }
}

#endif
