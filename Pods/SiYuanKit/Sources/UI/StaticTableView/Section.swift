//
//  Section.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-08-01.
//
//

import Foundation

/// Section structure, represents a section in a tableView.
public struct Section {
  /// rows for this section.
  public let rows: [Row]
  
  /// Title for this section.
  public let title: String?
  
  /// UUID.
  public let UUID: String
  
  public init(title: String? = nil,
               UUID: String = NSUUID().uuidString,
               rows: [Row] = []) {
    self.title = title
    self.UUID = UUID
    self.rows = rows
  }
}

extension Section: Hashable {
  public var hashValue: Int {
    return self.UUID.hashValue
  }
}

extension Section: Equatable { }

public func ==(lhs: Section, rhs: Section) -> Bool {
  return lhs.UUID == rhs.UUID
}
